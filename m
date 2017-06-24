Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:36264 "EHLO
        mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbdFXQRD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Jun 2017 12:17:03 -0400
Received: by mail-qk0-f173.google.com with SMTP id p21so54596573qke.3
        for <linux-wireless@vger.kernel.org>; Sat, 24 Jun 2017 09:17:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABWe71wAzCQKJ3rCE1pfVaxYxqucSUU0u3qwJYAUJ9xOmuz_bA@mail.gmail.com>
References: <CABWe71yk2NfAgw21men=uxoUZ5+CcetkKDLP3vE9v_yT=+F_Bw@mail.gmail.com>
 <CABWe71zX=UMML+cCoWbwkwcP1fewT7i+VGL-TEO_79wnd=WM7w@mail.gmail.com> <CABWe71wAzCQKJ3rCE1pfVaxYxqucSUU0u3qwJYAUJ9xOmuz_bA@mail.gmail.com>
From: =?UTF-8?B?5a2Z5bu65biM?= <ycsunjane@gmail.com>
Date: Sun, 25 Jun 2017 00:17:01 +0800
Message-ID: <CABWe71wRDY1Bq6UTmexzwfvDw4w_WGGY2jYXK=VRubbq3jDQjQ@mail.gmail.com> (sfid-20170624_181707_225569_A28B3876)
Subject: Re: ath9k wds mode station break off
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I catched the bug position:

in mac80211 ieee80211_sta_manage_reorder_buf function:

/* frame with out of date sequence number */
if (ieee80211_sn_less(mpdu_seq_num, head_seq_num)) {


ieee80211_sn_less will check seq_num. But in ath9k wds mode, I found
some time mpdu_seq_num will less than head_seq_num.  Then all recvieve
data packet will drop.

my log:

[ 8137.201050] mac80211 with out of date seq number: 3843 3890


On Sat, Jun 24, 2017 at 10:55 AM, =E5=AD=99=E5=BB=BA=E5=B8=8C <ycsunjane@gm=
ail.com> wrote:
> Hi,
>
> Why ap send deauth packet?
>
> I grep the source find deauth in ieee80211_rx_mgmt_deauth.
>
> On Sat, Jun 24, 2017 at 10:40 AM, =E5=AD=99=E5=BB=BA=E5=B8=8C <ycsunjane@=
gmail.com> wrote:
>> All:
>>
>> Add some debug info in mac80211, i can get data packet in
>> __ieee80211_rx_handle_packet
>>
>> 4053         if (ieee80211_is_mgmt(fc)) {
>> 4054                 mac80211_dbg(local, RX, "mac80211 mgmt
>> packet\n");
>> 4055                 /* drop frame if too short for header */
>>
>> 4083         } else if (ieee80211_is_data(fc)) {
>> 4084                 mac80211_dbg(local, RX, "mac80211 data
>> packet\n");
>> 4085                 struct sta_info *sta, *prev_sta;
>>
>> with ping packet log:
>>
>> [ 8996.617367] mac80211 data packet
>> [ 8996.622783] mac80211 mgmt packet
>> [ 8996.725036] mac80211 mgmt packet
>> [ 8996.820829] mac80211 data packet
>> [ 8996.829383] mac80211 mgmt packet
>> [ 8996.931682] mac80211 mgmt packet
>> [ 8997.033052] mac80211 mgmt packet
>> [ 8997.135956] mac80211 mgmt packet
>>
>>
>> And station will deauth from ap with PRE_AUTH_NOT_VALID:
>>
>> [ 8998.621385] wlan0: deauthenticated from c8:ee:a6:2d:cc:6c (Reason:
>> 2=3DPREV_AUTH_NOT_VALID)
>> [ 8998.629537] br-lan: port 2(wlan0) entered disabled state
>> [ 9003.635631] wlan0: authenticate with c8:ee:a6:2d:cc:6c
>> [ 9003.651230] wlan0: send auth to c8:ee:a6:2d:cc:6c (try 1/3)
>> [ 9003.670365] wlan0: associate with c8:ee:a6:2d:cc:6c (try 1/3)
>> [ 9003.681735] wlan0: RX AssocResp from c8:ee:a6:2d:cc:6c (capab=3D0x431
>> status=3D0 aid=3D1)
>> [ 9003.815829] br-lan: port 2(wlan0) entered forwarding state
>>
>>
>> I think some bug in auth cause data packet drop.
>>
>> On Sat, Jun 3, 2017 at 4:09 PM, =E5=AD=99=E5=BB=BA=E5=B8=8C <ycsunjane@g=
mail.com> wrote:
>>> wds ap:
>>>
>>>         config wifi-device 'radio0'
>>>                 option type 'mac80211'
>>>                 option hwmode '11g'
>>>                 option path 'platform/ar933x_wmac'
>>>                 option distance '3000'
>>>                 option txpower '18'
>>>                 option country '00'
>>>                 option channel '1'
>>>                 option htmode 'HT40'
>>>
>>>         config wifi-iface
>>>                 option device 'radio0'
>>>                 option network 'lan'
>>>                 option mode 'ap'
>>>                 option encryption 'psk2'
>>>                 option key '12345600'
>>>                option max_inactivity '20'
>>>                 option wds '1'
>>>                 option ssid 'LK-M2-Jianxi'
>>>
>>> wds station:
>>>
>>>         config wifi-device 'radio0'
>>>                 option type 'mac80211'
>>>                 option channel '1'
>>>                 option hwmode '11g'
>>>                 option path 'platform/ar933x_wmac'
>>>                 option htmode 'HT20'
>>>                 option distance '3000'
>>>                 option txpower '19'
>>>                option country '00'
>>>
>>>         config wifi-iface
>>>                 option device 'radio0'
>>>                 option network 'lan'
>>>                 option encryption 'psk2'
>>>                 option key '12345600'
>>>                 option max_inactivity '20'
>>>                 option wds '1'
>>>                 option mode 'sta'
>>>                 option ssid 'LK-M2-Jianxi'
>>>
>>>  When the station break off, ping can not reach ap. wifi still
>>> connect. kernel have no error info. iwinfo signal still change.
>>>
>>> ap with the other station still alive.
>>>
>>> Use wpa_cli scan command, will awake station, and ping alive.
>>> wifi command also work.
>>>
>>> /proc/interrupts ath9k still alive.
