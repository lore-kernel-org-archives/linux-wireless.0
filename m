Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34691 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932577AbcKVNBT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 08:01:19 -0500
Received: by mail-pg0-f65.google.com with SMTP id e9so2088866pgc.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2016 05:01:19 -0800 (PST)
Date: Tue, 22 Nov 2016 22:53:01 +1000
From: Barry Day <briselec@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Fix failure to reconnect to AP
Message-ID: <20161122125300.GB23278@testbox> (sfid-20161122_140124_397903_F08EE3DD)
References: <20161113111705.GA2393@box64.home.org>
 <wrfjoa1iyz1e.fsf@redhat.com>
 <wrfjbmx87oul.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfjbmx87oul.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 21, 2016 at 11:57:22AM -0500, Jes Sorensen wrote:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> > Barry Day <briselec@gmail.com> writes:
> >> The rtl8192e and rtl8723 fail to reconnect to an AP after being
> >> disconnected. Ths patch fixes that without affecting the rtl8192cu.
> >> I don't have a rtl8723 to test but it has been tested on a rtl8192eu.
> >> After going through the orginal realtek code for the rtl8723, I am
> >> confident the patch is applicable to both.
> >>
> >> Signed-off-by: Barry Day <briselec@gmail.com>
> >> ---
> >>  rtl8xxxu_core.c | 18 ++++++++++++++----
> >>  1 file changed, 14 insertions(+), 4 deletions(-)
> >
> > Hi Barry,
> >
> > Thank you for the patch. There are a couple of items which I am not
> > 100% sure about the order of.
> >
> >> diff --git a/rtl8xxxu_core.c b/rtl8xxxu_core.c
> >> index 04141e5..6ac10d2 100644
> >> --- a/rtl8xxxu_core.c
> >> +++ b/rtl8xxxu_core.c
> >> @@ -4372,17 +4372,25 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
> >>  void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
> >>  				  u8 macid, bool connect)
> >>  {
> >> +	u8 val8;
> >>  	struct h2c_cmd h2c;
> >>  
> >>  	memset(&h2c, 0, sizeof(struct h2c_cmd));
> >>  
> >>  	h2c.media_status_rpt.cmd = H2C_8723B_MEDIA_STATUS_RPT;
> >> -	if (connect)
> >> +	if (connect) {
> >>  		h2c.media_status_rpt.parm |= BIT(0);
> >> -	else
> >> -		h2c.media_status_rpt.parm &= ~BIT(0);
> >> +		rtl8xxxu_gen2_h2c_cmd(priv, &h2c,
> >> +					sizeof(h2c.media_status_rpt));
> >> +	} else {
> >> +		val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
> >> +		val8 &= ~BEACON_FUNCTION_ENABLE;
> >> +
> >> +		rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
> >> +		rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x00);
> >> +		rtl8xxxu_write8(priv, REG_DUAL_TSF_RST, (BIT(0) | BIT(1)));
> >> +	}
> >>  
> >> -	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
> >>  }
> 
> Barry,
> 
> So looking at this again, I am pretty sure you will break monitor mode
> with this. By setting REG_RXFLTMAP2 to 0x0000 you stop reception of all
> data frames.
> 
> The other thing here is that you change removes the part notifying the
> firmware that we disconnected since you now only send the
> media_start_rpt command on connect, but not on disconnect.
> 
> I am curious if the problem goes away if you simply add the BEACON_CTRL
> and REG_DUAL_TSF_RST parts?
> 
> >
> > This only affects 8192eu and not 8192cu - we left RXFLTMAP2 out of here
> > on purpose for monitor mode, but you now disable it for 8192eu/8723bu.
> >
> >>  void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
> >> @@ -4515,6 +4523,8 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> >>  				sgi = 1;
> >>  			rcu_read_unlock();
> >>  
> >> +			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0xffff);
> >> +
> >>  			priv->fops->update_rate_mask(priv, ramask, sgi);
> >>  
> >>  			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
> 
> I believe this change only matters because you disable RXFLTMAP2
> above. If we really have to write to RXFLTMAP2 to make this work, I
> suspect we need to keep some sort of state information.
> 
> I would also be curious if RXFLTMAP2 gets reset somehow by the firmware,
> and we do not account for that.
> 
> Cheers,
> Jes
> 

I'll redo the patch without touching REG_RXFLTMAP2. I don't think it's needed
to fix the fail to reconnect issue.

I haven't had a proper look at the 8723 chips yet but the vendor drivers for
the others don't do a h2c cmd for disconnect but I'll test leaving it in to see
if it makes any difference. A 8723bu arrived in the mail today so now I can
test it too and I discovered yesterday I have a 8723au but it's in a cheap
Android tablet.

Barry
