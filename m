Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53755 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab1A3Reh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 12:34:37 -0500
Message-ID: <4D45A128.6060905@candelatech.com>
Date: Sun, 30 Jan 2011 09:34:32 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Why is wmm_param required for HT40- in mlme.c
References: <4D44F94F.8040707@candelatech.com> <1296380208.3616.0.camel@jlt3.sipsolutions.net>
In-Reply-To: <1296380208.3616.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2011 01:36 AM, Johannes Berg wrote:
> On Sat, 2011-01-29 at 21:38 -0800, Ben Greear wrote:
>> I tried to set up hostapd to do HT40-, but for whatever reason,
>> it's not sending any wmm_param options, so the stations will not
>> associate with HT40- enabled due to the check below.
>>
>> Is it really *reqired* that wmm_param exist to enable HT mode?
>>
>>   From mlme.c:
>> 	if (elems.ht_info_elem&&  elems.wmm_param&&
>> 	(sdata->local->hw.queues>= 4)&&
>> 	!(ifmgd->flags&  IEEE80211_STA_DISABLE_11N))
>> 		changed |= ieee80211_enable_ht(sdata, elems.ht_info_elem,
>> 					       cbss->bssid, ap_ht_cap_flags);
>
> 802.11n-2009 says it is required.

Do you know the pertinent section, or some keywords to search for?  I'm
unable to find anything useful.

Also, from looking at utils.c, it seems that this wmm_param is
a vendor specific Microsoft thing?  I don't see anywhere else that
wmm_param is assigned...

		case WLAN_EID_VENDOR_SPECIFIC:
			if (elen >= 4 && pos[0] == 0x00 && pos[1] == 0x50 &&
			    pos[2] == 0xf2) {
				/* Microsoft OUI (00:50:F2) */

				if (calc_crc)
					crc = crc32_be(crc, pos - 2, elen + 2);

				if (pos[3] == 1) {
					/* OUI Type 1 - WPA IE */
					elems->wpa = pos;
					elems->wpa_len = elen;
				} else if (elen >= 5 && pos[3] == 2) {
					/* OUI Type 2 - WMM IE */
					if (pos[4] == 0) {
						elems->wmm_info = pos;
						elems->wmm_info_len = elen;
					} else if (pos[4] == 1) {
						elems->wmm_param = pos;
						elems->wmm_param_len = elen;
					}
				}
			}
			break;

Thanks,
Ben

>
> johannes


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
