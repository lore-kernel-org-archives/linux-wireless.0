Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:45487 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbYJQBM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 21:12:57 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 7/6] p54: integrate parts of lmac_longbow.h and other parts of stlc45xx
Date: Fri, 17 Oct 2008 03:17:09 +0200
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Pavel Roskin <proski@gnu.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>
References: <200810150408.44363.chunkeey@web.de> <200810162320.13106.chunkeey@web.de> <1224196221.6287.18.camel@brick>
In-Reply-To: <1224196221.6287.18.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200810170317.09742.chunkeey@web.de> (sfid-20081017_031302_617935_95DF9EA7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 17 October 2008 00:30:21 Harvey Harrison wrote:
> On Thu, 2008-10-16 at 23:20 +0200, Christian Lamparter wrote:
> > On Thursday 16 October 2008 17:46:18 Larry Finger wrote:
> > > The following change of ack_rssi from __le16 to u8 generates the sparse warning
> > > "drivers/net/wireless/p54/p54common.c:660:5: warning: cast to restricted __le16":
> > > 
> 
> > @@ -739,9 +777,9 @@ static int p54_rx_control(struct ieee802
> >  /* returns zero if skb can be reused */
> >  int p54_rx(struct ieee80211_hw *dev, struct sk_buff *skb)
> >  {
> > -	u8 type = le16_to_cpu(*((__le16 *)skb->data)) >> 8;
> > +	u16 type = le16_to_cpu(*((__le16 *)skb->data));
> 
> 	u16 type = le16_to_cpup((__le16 *)skb->data);
> 
should be fixed in [PATCH 1/3] p54: more definitions form lmac_longbow.h and pda.h
> > +
> > +#ifndef WLAN_FC_GET_TYPE
> > +#define WLAN_FC_GET_TYPE(fc) (fc & IEEE80211_FCTL_FTYPE)
> > +#define WLAN_FC_GET_STYPE(fc) (fc & IEEE80211_FCTL_STYPE)
> > +#endif
> > +
> 
> Suggest you look into some of the helpers in ieee80211.h
ohh well, I could have updated that code ;-)
> 
> > +
> > +static int p54_tx_fill(struct ieee80211_hw *dev, struct sk_buff *skb,
> > +		struct ieee80211_tx_info* info, u8 *queue, size_t *extra_len,
> > +		u16 *flags, u16 *aid)
> > +{
> > +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> > +	struct p54_common *priv = dev->priv;
> > +	u16 fc = le16_to_cpu(hdr->frame_control);
> 
> 	__le16 fc = hdr->frame_control;
> 
> > +	int ret = 0;
> > +
> > +	if (unlikely(WLAN_FC_GET_TYPE(fc) == IEEE80211_FTYPE_MGMT)) {
> 
> 	ieee80211_is_mgmt(fc);
> 
> > +		switch (WLAN_FC_GET_STYPE(fc)) {
> 
> Not sure what the prevailing wisdom is here, switch to if /else if using
> the helpers ieee80211_is_beacon(fc), ieee80211_is_probe_resp to do
> compile-time byteswaps.
> 
> or
> 		switch (fc & cpu_to_le16(IEEE80211_FCTL_STYPE)
> 		case cpu_to_le16(IEEE80211_STYPE_BEACON):
> 
> etc.
k!
> 
> > +		case IEEE80211_STYPE_BEACON:
> > +			*aid = 0;
> > +			*queue = 0;
> > +			*extra_len = IEEE80211_MAX_TIM_LEN;
> > +			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP;
> > +			return 0;
> > +		case IEEE80211_STYPE_PROBE_RESP:
> > +			*aid = 0;
> > +			*queue = 2;
> > +			*flags = P54_HDR_FLAG_DATA_OUT_TIMESTAMP |
> > +				 P54_HDR_FLAG_DATA_OUT_NOCANCEL;
> > +			return 0;
> > +		default:
> > +			*queue = 2;
> > +			ret = 0;
> 
> 		return?
return?
p54 has 8 queues:
 - 4 WME queues which neatly fit into mac80211's concept... (that's when we return 1)
 - the other 4 don't. that's when we return 0. 
   (otherwise, we won't stop the WME queue for no reason)

Thanks,
	Chr
