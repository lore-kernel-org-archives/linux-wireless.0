Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0097.hostedemail.com ([216.40.44.97]:55872 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752740AbdHOA7s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Aug 2017 20:59:48 -0400
Message-ID: <1502758784.8295.30.camel@perches.com> (sfid-20170815_025951_801974_582C5EE3)
Subject: Re: [PATCH v2 09/10] rtlwifi: use debugfs to debug.
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Date: Mon, 14 Aug 2017 17:59:44 -0700
In-Reply-To: <9007f821-764b-9bd5-da13-bcbd032e57e1@lwfinger.net>
References: <20170625154344.19213-1-Larry.Finger@lwfinger.net>
         <20170625154344.19213-10-Larry.Finger@lwfinger.net>
         <1502736968.8295.22.camel@perches.com>
         <9007f821-764b-9bd5-da13-bcbd032e57e1@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-08-14 at 16:17 -0500, Larry Finger wrote:
> On 08/14/2017 01:56 PM, Joe Perches wrote:
> > On Sun, 2017-06-25 at 10:43 -0500, Larry Finger wrote:
> > > From: Ping-Ke Shih <pkshih@realtek.com>
> > > 
> > > Use debugfs to dump register and btcoex status.
> > 
> > []
> > > diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.c b/drivers/net/wireless/realtek/rtlwifi/debug.c
> > 
> > []
> > > +void rtl_debug_add_one(struct ieee80211_hw *hw)
> > > +{
> > > +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> > > +	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
> > > +	struct dentry *parent;
> > > +
> > > +	snprintf(rtlpriv->dbg.debugfs_name, 18, "%02x-%02x-%02x-%02x-%02x-%02x",
> > > +		 rtlefuse->dev_addr[0], rtlefuse->dev_addr[1],
> > > +		 rtlefuse->dev_addr[2], rtlefuse->dev_addr[3],
> > > +		 rtlefuse->dev_addr[4], rtlefuse->dev_addr[5]);
> > 
> > Why uses dashes and why not just use %pM
> 
> This snprintf() supplies the MAC address in a file name of the type
> /sys/kernel/debug/rtlwifi/00-11-22-33-44-55-66/mac_0
> Using %pM would put colons there, and I have had trouble with colons in a file 
> name. We could use %#pM and drop the separators.

%pm emits without colons
