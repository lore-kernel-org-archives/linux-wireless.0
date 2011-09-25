Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:23501 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598Ab1IYJUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Sep 2011 05:20:46 -0400
Date: Sun, 25 Sep 2011 14:51:26 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Eliad Peller <eliad@wizery.com>
CC: <johannes@sipsolutions.net>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] mac80211: Send the management frame at requested rate
Message-ID: <20110925092124.GA927@vmraj-lnx.users.atheros.com> (sfid-20110925_112050_736292_3E950C77)
References: <1316790779-8955-1-git-send-email-rmanohar@qca.qualcomm.com>
 <1316790779-8955-2-git-send-email-rmanohar@qca.qualcomm.com>
 <CAB3XZEf0A4fVCrLoCTGy+XndSW412rwTcUyL9tQ6YjoDsYonyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <CAB3XZEf0A4fVCrLoCTGy+XndSW412rwTcUyL9tQ6YjoDsYonyA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 25, 2011 at 11:58:47AM +0300, Eliad Peller wrote:
> On Fri, Sep 23, 2011 at 6:12 PM, Rajkumar Manoharan
> <rmanohar@qca.qualcomm.com> wrote:
> > Whenever the scan request or tx_mgmt is requesting not to
> > use CCK rate for managemet frames through
> > NL80211_ATTR_TX_NO_CCK_RATE attribute, then mac80211 should
> > select appropriate least non-CCK rate. This could help to
> > send P2P probes and P2P action frames at non 11b rates
> > without diabling 11b rates globally.
> >
> > Cc: Jouni Malinen <jouni@qca.qualcomm.com>
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> > ---
> [...]
> 
> > +static inline s8
> > +rate_lowest_non_cck_index(struct ieee80211_supported_band *sband,
> > +                         struct ieee80211_sta *sta)
> > +{
> > +       int i;
> > +
> > +       for (i = 0; i < sband->n_bitrates; i++) {
> > +               struct ieee80211_rate *srate = &sband->bitrates[i];
> > +               if ((srate->bitrate == 10) || (srate->bitrate == 20) ||
> > +                   (srate->bitrate == 55) || (srate->bitrate == 110))
> > +                       continue;
> > +
> > +               if ((i != sband->n_bitrates) &&
> > +                   rate_supported(sta, sband->band, i))
> > +                       return i;
> 
> the first condition seems redundant (according to the loop condition,
> i < sband->n_bitrates)
Yeah. i missed it ;)

--
Rajkumar
