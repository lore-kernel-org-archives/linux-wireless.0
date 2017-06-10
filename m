Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 220-135-115-6.HINET-IP.hinet.net ([220.135.115.6]:41819 "EHLO
        ns.kevlo.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751678AbdFJOXh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 10:23:37 -0400
Date: Sat, 10 Jun 2017 22:23:16 +0800
From: Kevin Lo <kevlo@kevlo.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: fix REG_USTIME_TSF register definition
Message-ID: <20170610142316.GA9284@ns.kevlo.org> (sfid-20170610_162350_358955_BED1D0A8)
References: <20170519150240.GA47825@ns.kevlo.org>
 <CA+R5OdtxiN4XBZg3k-Suamj5r4+=jDY-10HdUCHuqb=Nt-baqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CA+R5OdtxiN4XBZg3k-Suamj5r4+=jDY-10HdUCHuqb=Nt-baqg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for the top post.  This patch has an Acked-by Yan-Hsuan Chuang.

On Wed, Jun 07, 2017 at 09:43:21AM +0800, 莊彥宣 wrote:
> Yes, the register 0x55c is for REG_USTIME_TSF.
> And 0x551 is for BCN_CTRL1.
> 
> 
> Acked-by: Yan-Hsuan, Chuang <yhchuang@realtek.com>
> 
> 2017-05-19 23:02 GMT+08:00 Kevin Lo <kevlo@kevlo.org>:
> 
> > The REG_USTIME_TSF (US Time Tuning for TSF) definition of Realtek chips
> > should be 0x55C.
> >
> > Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> > ---
> >
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
> > b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
> > index 15400ee6c04b..0c0d64aea651 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/reg.h
> > @@ -248,7 +248,6 @@
> >  #define REG_RD_NAV_NXT                         0x0544
> >  #define REG_NAV_PROT_LEN                       0x0546
> >  #define REG_BCN_CTRL                           0x0550
> > -#define REG_USTIME_TSF                         0x0551
> >  #define REG_MBID_NUM                           0x0552
> >  #define REG_DUAL_TSF_RST                       0x0553
> >  #define REG_BCN_INTERVAL                       0x0554
> > @@ -256,6 +255,7 @@
> >  #define REG_DRVERLYINT                         0x0558
> >  #define REG_BCNDMATIM                          0x0559
> >  #define REG_ATIMWND                                    0x055A
> > +#define REG_USTIME_TSF                         0x055C
> >  #define REG_BCN_MAX_ERR                                0x055D
> >  #define REG_RXTSF_OFFSET_CCK           0x055E
> >  #define REG_RXTSF_OFFSET_OFDM          0x055F
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
> > b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
> > index 1bb7ed35812d..9e3b58a5d2bb 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/reg.h
> > @@ -227,7 +227,6 @@
> >  #define REG_RD_NAV_NXT                         0x0544
> >  #define REG_NAV_PROT_LEN                       0x0546
> >  #define REG_BCN_CTRL                           0x0550
> > -#define REG_USTIME_TSF                         0x0551
> >  #define REG_MBID_NUM                           0x0552
> >  #define REG_DUAL_TSF_RST                       0x0553
> >  #define REG_BCN_INTERVAL                       0x0554
> > @@ -235,6 +234,7 @@
> >  #define REG_DRVERLYINT                         0x0558
> >  #define REG_BCNDMATIM                          0x0559
> >  #define REG_ATIMWND                            0x055A
> > +#define REG_USTIME_TSF                         0x055C
> >  #define REG_BCN_MAX_ERR                                0x055D
> >  #define REG_RXTSF_OFFSET_CCK                   0x055E
> >  #define REG_RXTSF_OFFSET_OFDM                  0x055F
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
> > b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
> > index b354b95936e2..d4c4e76a9244 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
> > @@ -255,7 +255,6 @@
> >  #define REG_RD_NAV_NXT                 0x0544
> >  #define REG_NAV_PROT_LEN               0x0546
> >  #define REG_BCN_CTRL                   0x0550
> > -#define REG_USTIME_TSF                 0x0551
> >  #define REG_MBID_NUM                   0x0552
> >  #define REG_DUAL_TSF_RST               0x0553
> >  #define REG_BCN_INTERVAL               0x0554
> > @@ -263,6 +262,7 @@
> >  #define REG_DRVERLYINT                 0x0558
> >  #define REG_BCNDMATIM                  0x0559
> >  #define REG_ATIMWND                    0x055A
> > +#define REG_USTIME_TSF                 0x055C
> >  #define REG_BCN_MAX_ERR                        0x055D
> >  #define REG_RXTSF_OFFSET_CCK           0x055E
> >  #define REG_RXTSF_OFFSET_OFDM          0x055F
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h
> > b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h
> > index 306059f9b9cc..30938cd9fce5 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/reg.h
> > @@ -217,7 +217,6 @@
> >  #define REG_RD_NAV_NXT                         0x0544
> >  #define REG_NAV_PROT_LEN                       0x0546
> >  #define REG_BCN_CTRL                           0x0550
> > -#define REG_USTIME_TSF                         0x0551
> >  #define REG_MBID_NUM                           0x0552
> >  #define REG_DUAL_TSF_RST                       0x0553
> >  #define REG_BCN_INTERVAL                       0x0554
> > @@ -225,6 +224,7 @@
> >  #define REG_DRVERLYINT                         0x0558
> >  #define REG_BCNDMATIM                          0x0559
> >  #define REG_ATIMWND                                    0x055A
> > +#define REG_USTIME_TSF                         0x055C
> >  #define REG_BCN_MAX_ERR                                0x055D
> >  #define REG_RXTSF_OFFSET_CCK           0x055E
> >  #define REG_RXTSF_OFFSET_OFDM          0x055F
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h
> > b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h
> > index 03581d2a5da0..95c4f8e206c7 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/reg.h
> > @@ -261,7 +261,6 @@
> >  #define REG_RD_NAV_NXT                         0x0544
> >  #define REG_NAV_PROT_LEN                       0x0546
> >  #define REG_BCN_CTRL                           0x0550
> > -#define REG_USTIME_TSF                         0x0551
> >  #define REG_MBID_NUM                           0x0552
> >  #define REG_DUAL_TSF_RST                       0x0553
> >  #define REG_BCN_INTERVAL                       0x0554
> > @@ -269,6 +268,7 @@
> >  #define REG_DRVERLYINT                         0x0558
> >  #define REG_BCNDMATIM                          0x0559
> >  #define REG_ATIMWND                            0x055A
> > +#define REG_USTIME_TSF                         0x055C
> >  #define REG_BCN_MAX_ERR                                0x055D
> >  #define REG_RXTSF_OFFSET_CCK                   0x055E
> >  #define REG_RXTSF_OFFSET_OFDM                  0x055F
> > diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
> > b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
> > index ed69dbe178ff..db8bc8a2de61 100644
> > --- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
> > +++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/reg.h
> > @@ -267,7 +267,6 @@
> >  #define REG_RD_NAV_NXT                         0x0544
> >  #define REG_NAV_PROT_LEN                       0x0546
> >  #define REG_BCN_CTRL                           0x0550
> > -#define REG_USTIME_TSF                         0x0551
> >  #define REG_MBID_NUM                           0x0552
> >  #define REG_DUAL_TSF_RST                       0x0553
> >  #define REG_BCN_INTERVAL                       0x0554
> > @@ -275,6 +274,7 @@
> >  #define REG_DRVERLYINT                         0x0558
> >  #define REG_BCNDMATIM                          0x0559
> >  #define REG_ATIMWND                            0x055A
> > +#define REG_USTIME_TSF                         0x055C
> >  #define REG_BCN_MAX_ERR                                0x055D
> >  #define REG_RXTSF_OFFSET_CCK                   0x055E
> >  #define REG_RXTSF_OFFSET_OFDM                  0x055F
> >
