Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:33507 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753423AbcKNQNM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 11:13:12 -0500
Received: by mail-pg0-f68.google.com with SMTP id 3so9312658pgd.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 08:13:12 -0800 (PST)
Date: Tue, 15 Nov 2016 02:05:05 +1000
From: Barry Day <briselec@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Fix failure to reconnect to AP
Message-ID: <20161114160504.GA12996@testbox> (sfid-20161114_171316_474055_0BDEFB67)
References: <20161113111705.GA2393@box64.home.org>
 <wrfjoa1iyz1e.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <wrfjoa1iyz1e.fsf@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 14, 2016 at 08:24:45AM -0500, Jes Sorensen wrote:
> Barry Day <briselec@gmail.com> writes:
> > The rtl8192e and rtl8723 fail to reconnect to an AP after being
> > disconnected. Ths patch fixes that without affecting the rtl8192cu.
> > I don't have a rtl8723 to test but it has been tested on a rtl8192eu.
> > After going through the orginal realtek code for the rtl8723, I am
> > confident the patch is applicable to both.
> >
> > Signed-off-by: Barry Day <briselec@gmail.com>
> > ---
> >  rtl8xxxu_core.c | 18 ++++++++++++++----
> >  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> Hi Barry,
> 
> Thank you for the patch. There are a couple of items which I am not
> 100% sure about the order of.
> 
> > diff --git a/rtl8xxxu_core.c b/rtl8xxxu_core.c
> > index 04141e5..6ac10d2 100644
> > --- a/rtl8xxxu_core.c
> > +++ b/rtl8xxxu_core.c
> > @@ -4372,17 +4372,25 @@ void rtl8xxxu_gen1_report_connect(struct rtl8xxxu_priv *priv,
> >  void rtl8xxxu_gen2_report_connect(struct rtl8xxxu_priv *priv,
> >  				  u8 macid, bool connect)
> >  {
> > +	u8 val8;
> >  	struct h2c_cmd h2c;
> >  
> >  	memset(&h2c, 0, sizeof(struct h2c_cmd));
> >  
> >  	h2c.media_status_rpt.cmd = H2C_8723B_MEDIA_STATUS_RPT;
> > -	if (connect)
> > +	if (connect) {
> >  		h2c.media_status_rpt.parm |= BIT(0);
> > -	else
> > -		h2c.media_status_rpt.parm &= ~BIT(0);
> > +		rtl8xxxu_gen2_h2c_cmd(priv, &h2c,
> > +					sizeof(h2c.media_status_rpt));
> > +	} else {
> > +		val8 = rtl8xxxu_read8(priv, REG_BEACON_CTRL);
> > +		val8 &= ~BEACON_FUNCTION_ENABLE;
> > +
> > +		rtl8xxxu_write8(priv, REG_BEACON_CTRL, val8);
> > +		rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0x00);
> > +		rtl8xxxu_write8(priv, REG_DUAL_TSF_RST, (BIT(0) | BIT(1)));
> > +	}
> >  
> > -	rtl8xxxu_gen2_h2c_cmd(priv, &h2c, sizeof(h2c.media_status_rpt));
> >  }
> 
> This only affects 8192eu and not 8192cu - we left RXFLTMAP2 out of here
> on purpose for monitor mode, but you now disable it for 8192eu/8723bu.
> 

Even in monitor mode the interface has to brought up to use it which invokes
rtl8xxxu_start which sets it back to accepting frames.


> >  void rtl8xxxu_gen1_init_aggregation(struct rtl8xxxu_priv *priv)
> > @@ -4515,6 +4523,8 @@ rtl8xxxu_bss_info_changed(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> >  				sgi = 1;
> >  			rcu_read_unlock();
> >  
> > +			rtl8xxxu_write16(priv, REG_RXFLTMAP2, 0xffff);
> > +
> >  			priv->fops->update_rate_mask(priv, ramask, sgi);
> >  
> >  			rtl8xxxu_write8(priv, REG_BCN_MAX_ERR, 0xff);
> 
> Here you enable RXFLTMAP2 for all devices - this doesn't balance with
> the above.
> 

The original realtek code I have for the 8192cu does the disconnect the
same way as in this patch. I tested the 8192cu using the patched
gen2_report connect and it works. That would make things consistent across
all chipsets.
