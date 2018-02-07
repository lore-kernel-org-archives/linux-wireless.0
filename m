Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:41885 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754327AbeBGUvi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 15:51:38 -0500
Received: by mail-pf0-f196.google.com with SMTP id 68so844060pfj.8
        for <linux-wireless@vger.kernel.org>; Wed, 07 Feb 2018 12:51:38 -0800 (PST)
Date: Wed, 7 Feb 2018 12:51:36 -0800
From: Matthias Kaehlcke <mka@chromium.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <groeck@chromium.org>,
        Justin TerAvest <teravest@chromium.org>,
        Craig Bergstrom <craigb@chromium.org>
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Remove variable self-assignment in
 rf.c
Message-ID: <20180207205136.GB116483@google.com> (sfid-20180207_215152_593506_E371E948)
References: <20180207202634.98937-1-mka@chromium.org>
 <947198f5-23eb-afbc-7979-fbc38b6a1a37@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <947198f5-23eb-afbc-7979-fbc38b6a1a37@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El Wed, Feb 07, 2018 at 02:35:59PM -0600 Larry Finger ha dit:

> On 02/07/2018 02:26 PM, Matthias Kaehlcke wrote:
> > In _rtl92c_get_txpower_writeval_by_regulatory() the variable writeVal
> > is assigned to itself in an if ... else statement, apparently only to
> > document that the branch condition is handled and that a previously read
> > value should be returned unmodified. The self-assignment causes clang to
> > raise the following warning:
> > 
> > drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c:304:13:
> >    error: explicitly assigning value of variable of type 'u32'
> >      (aka 'unsigned int') to itself [-Werror,-Wself-assign]
> >    writeVal = writeVal;
> > 
> > Replace the self-assignment with a semicolon, which still serves to
> > document the 'handling' of the branch condition.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> >   drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> > index 9cff6bc4049c..4db92496c122 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/rf.c
> > @@ -301,7 +301,7 @@ static void _rtl92c_get_txpower_writeval_by_regulatory(struct ieee80211_hw *hw,
> >   			writeVal = writeVal - 0x06060606;
> >   		else if (rtlpriv->dm.dynamic_txhighpower_lvl ==
> >   			 TXHIGHPWRLEVEL_BT2)
> > -			writeVal = writeVal;
> > +			;
> >   		*(p_outwriteval + rf) = writeVal;
> >   	}
> >   }
> > 
> 
> As the branch condition does nothing, why not remove it and save the
> compiler's optimizer a bit of work? The code looks strange, but it matches
> the rest of Realtek's USB drivers.

Sure, I am happy to change it to whatever the authors/maintainers prefer.

I'll wait a bit before respinning for if others feel strongly about
keeping the branch.
