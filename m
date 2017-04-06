Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:34115 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754145AbdDFXy3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Apr 2017 19:54:29 -0400
Received: by mail-pg0-f50.google.com with SMTP id 21so49486244pgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Apr 2017 16:54:28 -0700 (PDT)
Date: Thu, 6 Apr 2017 16:54:27 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Grant Grundler <grundler@chromium.org>
Subject: Re: [PATCH] ath9k: Add cast to u8 to FREQ2FBIN macro
Message-ID: <20170406235427.GC78690@google.com> (sfid-20170407_015433_275297_0B461F87)
References: <20170406212135.72157-1-mka@chromium.org>
 <1491514160.27353.102.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1491514160.27353.102.camel@perches.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

El Thu, Apr 06, 2017 at 02:29:20PM -0700 Joe Perches ha dit:

> On Thu, 2017-04-06 at 14:21 -0700, Matthias Kaehlcke wrote:
> > The macro results are assigned to u8 variables/fields. Adding the cast
> > fixes plenty of clang warnings about "implicit conversion from 'int' to
> > 'u8'".
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> >  drivers/net/wireless/ath/ath9k/eeprom.h | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/wireless/ath/ath9k/eeprom.h b/drivers/net/wireless/ath/ath9k/eeprom.h
> > index 30bf722e33ed..31390af6c33e 100644
> > --- a/drivers/net/wireless/ath/ath9k/eeprom.h
> > +++ b/drivers/net/wireless/ath/ath9k/eeprom.h
> > @@ -106,7 +106,7 @@
> >  #define AR9285_RDEXT_DEFAULT    0x1F
> >  
> >  #define ATH9K_POW_SM(_r, _s)	(((_r) & 0x3f) << (_s))
> > -#define FREQ2FBIN(x, y)		((y) ? ((x) - 2300) : (((x) - 4800) / 5))
> > +#define FREQ2FBIN(x, y)		(u8)((y) ? ((x) - 2300) : (((x) - 4800) / 5))
> 
> Maybe better to use:
> 
> static inline u8 FREQ2FBIN(int x, int y)
> {
> 	if (y)
> 		return x - 2300;
> 	return (x - 4800) / 5;
> }

Thanks for your suggestion! Unfortunately in this case an inline
function is not suitable since FREQ2FBIN() is mostly used for
structure initialization:

static const struct ar9300_eeprom ar9300_default = {
...
        .calFreqPier2G = {
                FREQ2FBIN(2412, 1),
                FREQ2FBIN(2437, 1),
                FREQ2FBIN(2472, 1),
        },
...

Cheers

Matthias
