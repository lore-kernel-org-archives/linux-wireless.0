Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:46872 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755021Ab2KZMVe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 07:21:34 -0500
Message-ID: <50B35DA1.7050006@neratec.com> (sfid-20121126_132138_141818_C616A228)
Date: Mon, 26 Nov 2012 13:16:33 +0100
From: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/1] ath9k: Add radiotap vendor specific data example
References: <1353667565-4212-1-git-send-email-Wojciech.Dubowik@neratec.com> <CAD2nsn0xrnWbrEZzhaKhipuwE-Hyc-KpCEWcuef+=NeF0gFmDg@mail.gmail.com>
In-Reply-To: <CAD2nsn0xrnWbrEZzhaKhipuwE-Hyc-KpCEWcuef+=NeF0gFmDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2012 12:22 PM, Mohammed Shafi wrote:
> On Fri, Nov 23, 2012 at 4:16 PM, Wojciech Dubowik
> <Wojciech.Dubowik@neratec.com> wrote:
>> As an exmaple of vendor specific data we can extract rssi
>> and evm values for all the chains so one can see them on
>> per packet basis. More can be added depending on the needs i.e.
>> noise floor, Ness, STBC, key miss, etc.
>> AtheorsC OUI is used in this example but it should be replaced
>> by own when in use.
>>
>> Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
>> ---
>>   drivers/net/wireless/ath/ath9k/recv.c |   33 +++++++++++++++++++++++++++++++++
>>   1 file changed, 33 insertions(+)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
>> index 6aafbb7..02c36c4 100644
>> --- a/drivers/net/wireless/ath/ath9k/recv.c
>> +++ b/drivers/net/wireless/ath/ath9k/recv.c
>> @@ -1246,6 +1246,39 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
>>                  if ((ah->caps.hw_caps & ATH9K_HW_CAP_ANT_DIV_COMB) && sc->ant_rx == 3)
>>                          ath_ant_comb_scan(sc, &rs);
>>
>> +#if 0
> please remove ifdefs .
I guess radiotap can bring quite some overhead so myabe instead of 
ifdefs I could
implement sysfs entry to enable/disable it? Could be also used to switch 
needed
fields suggested by Johannes.
>
>
>> +               /*TODO: Replace oui and vendor sub namespace with valid data
>> +                * and add/remove fields below
>> +                */
>> +               if( skb_headroom(skb) >  22 ) {
>> +                       int8_t* vendor_data;
> we can use s8 ?
Will do.
>
>
>> +
>> +                       vendor_data = skb_push(skb, 22);
>> +
>> +                       rxs->vendor_radiotap_len = 22;
>> +                       rxs->vendor_radiotap_align = 4;
>> +                       rxs->vendor_radiotap_oui[0] = 0x0;
>> +                       rxs->vendor_radiotap_oui[1] = 0x3;
>> +                       rxs->vendor_radiotap_oui[2] = 0x7f;
>> +                       rxs->vendor_radiotap_subns = 0;
>> +                       rxs->vendor_radiotap_bitmap = 0x00000001;
>> +
>> +                       /* count bytes below and put it as the length*/
>> +                       *vendor_data++ = rs.rs_rssi;
>> +                       *vendor_data++ = rs.rs_rssi_ctl0;
>> +                       *vendor_data++ = rs.rs_rssi_ctl1;
>> +                       *vendor_data++ = rs.rs_rssi_ctl2;
>> +                       put_unaligned_le32(rs.evm0, vendor_data);
>> +                       vendor_data += 4;
>> +                       put_unaligned_le32(rs.evm1, vendor_data);
>> +                       vendor_data += 4;
>> +                       put_unaligned_le32(rs.evm2, vendor_data);
>> +                       vendor_data += 4;
>> +                       put_unaligned_le32(rs.evm3, vendor_data);
>> +                       vendor_data += 4;
>> +                       put_unaligned_le16(rs.evm4, vendor_data);
>> +               }
>> +#endif
>
> would be nice check this stuff in sniffer.
You mean dissect it?
>
>>                  ieee80211_rx(hw, skb);
>>
>>   requeue_drop_frag:
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

