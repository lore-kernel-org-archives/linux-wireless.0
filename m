Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40226 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481AbaCXGK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 02:10:28 -0400
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id CC5DE20C8B
	for <linux-wireless@vger.kernel.org>; Mon, 24 Mar 2014 02:10:27 -0400 (EDT)
Date: Sun, 23 Mar 2014 23:12:01 -0700
From: Greg KH <greg@kroah.com>
To: Adam Lee <adam.lee@canonical.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	stable@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: rtl8188ee: enable MSI interrupts support
Message-ID: <20140324061201.GA30798@kroah.com> (sfid-20140324_071038_132642_E04F06D1)
References: <1395640841-14477-1-git-send-email-adam.lee@canonical.com>
 <20140324060512.GA3657@adam-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140324060512.GA3657@adam-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 24, 2014 at 02:05:21PM +0800, Adam Lee wrote:
> On Mon, Mar 24, 2014 at 02:00:41PM +0800, Adam Lee wrote:
> > Some HP notebooks using this rtl8188ee hardware module can't get
> > AP scan results with pin-based interrupts, enabling MSI interrupts could
> > fix it.
> > 
> > Signed-off-by: Adam Lee <adam.lee@canonical.com>
> > ---
> >  drivers/net/wireless/rtlwifi/rtl8188ee/sw.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> > index 347af1e..1b4101b 100644
> > --- a/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> > +++ b/drivers/net/wireless/rtlwifi/rtl8188ee/sw.c
> > @@ -93,6 +93,7 @@ int rtl88e_init_sw_vars(struct ieee80211_hw *hw)
> >  	u8 tid;
> >  
> >  	rtl8188ee_bt_reg_init(hw);
> > +	rtlpci->msi_support = true;
> >  
> >  	rtlpriv->dm.dm_initialgain_enable = 1;
> >  	rtlpriv->dm.dm_flag = 0;
> > -- 
> > 1.9.1
> 
> Cc: stable@vger.kernel.org


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
