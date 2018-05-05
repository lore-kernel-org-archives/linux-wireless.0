Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:54480 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750988AbeEEJuo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 May 2018 05:50:44 -0400
Subject: Re: [PATCH] ath10k: add dynamic vlan support
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        johannes@sipsolutions.net
Cc: Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
References: <1524232653-22573-1-git-send-email-mpubbise@codeaurora.org>
 <87r2n5auvq.fsf@kamboji.qca.qualcomm.com>
 <aa04534d-9677-f42e-a239-b230093ef2f5@dd-wrt.com>
 <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <7ad37979-b2fb-b358-4187-23ea88654f90@dd-wrt.com> (sfid-20180505_115049_670853_B87BEC3E)
Date: Sat, 5 May 2018 11:50:42 +0200
MIME-Version: 1.0
In-Reply-To: <f8d6d13943ccac22f363d7d4f53d645c@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

did someone notice that GTK rekeying is broken in 4addr mode for 10.4. 
firmwares since a long time.
i have a test with 2 9984 devices. one is 4addr ap, the second 4addr 
sta. it disconnects on rekeying and reauthenticates. (reproducable with 
99x0 as well)
this does not occur on 10.2 based chipsets like 988x. it seems to be a 
internal firmware problem since the beginning. i wrote already a long 
time ago about it,
but no solution was provided. maybe its also finally time to take care 
about this issue (cause unknown)

Sebastian

Am 04.05.2018 um 08:50 schrieb Manikanta Pubbisetty:
> Johannes,
>
> It seems like commit db3bdcb9c3ff ("mac80211: allow AP_VLAN operation 
> on crypto controlled devices") has broken 4-addr operation on crypto 
> controlled devices as reported by sebastian.
> The commit was mainly focused in addressing the problem in supporting 
> VLANs on crypto controlled devices but since 4-addr mode is also 
> dependent on AP_VLAN interface, this commit breaks the 4-addr AP mode.
>
> I have couple of ideas on how to address the problem,
>
> 1) Add a new hw_flag and based on the hardware flag, allow/disallow 
> the creation of AP_VLAN interface.
>
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index d2279b2..301d9c38 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -2084,6 +2084,11 @@ struct ieee80211_txq {
>   * @IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP: The driver (or firmware) 
> doesn't
>   *     support QoS NDP for AP probing - that's most likely a driver bug.
>   *
> + * @IEEE80211_HW_SUPPORTS_SW_ENCRYPT: Device is capable of transmitting
> + *     frames encrypted in software, only valid when SW_CRYPTO_CONTROL
> + *     is enabled. Based on this flag, mac80211 can allow/disallow VLAN
> + *     operations in the BSS.
> + *
>   * @NUM_IEEE80211_HW_FLAGS: number of hardware flags, used for sizing 
> arrays
>   */
>  enum ieee80211_hw_flags {
> @@ -2129,6 +2134,7 @@ enum ieee80211_hw_flags {
>         IEEE80211_HW_SUPPORTS_TDLS_BUFFER_STA,
>         IEEE80211_HW_DEAUTH_NEED_MGD_TX_PREP,
>         IEEE80211_HW_DOESNT_SUPPORT_QOS_NDP,
> +       IEEE80211_HW_SUPPORTS_SW_ENCRYPT,
>
>         /* keep last, obviously */
>         NUM_IEEE80211_HW_FLAGS
> diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> index 555e389..c825d27 100644
> --- a/net/mac80211/iface.c
> +++ b/net/mac80211/iface.c
> @@ -1736,6 +1736,11 @@ int ieee80211_if_add(struct ieee80211_local 
> *local, const char *name,
>
>         ASSERT_RTNL();
>
> +       if ((type == NL80211_IFTYPE_AP_VLAN) && !params->use_4addr &&
> +           ieee80211_hw_check(local->hw, SW_CRYPTO_CONTROL) &&
> +           !ieee80211_hw_check(local->hw, SUPPORTS_SW_ENCRYPT))
> +              return -EOPNOTSUPP;
> +
>         if (type == NL80211_IFTYPE_P2P_DEVICE || type == 
> NL80211_IFTYPE_NAN) {
>                 struct wireless_dev *wdev;
>
> 2) Allow mac80211 to call set_key for GTKs on AP_VLAN interfaces for 
> crypto controlled devices, let the driver decide whether to return '1' 
> or some error code based on their support for transmitting sw 
> encrypted frames. I am little skeptical with this approach as drivers 
> are totally unaware of AP_VLAN interfaces.
>
> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
> index ee0d0cc..0ff5597 100644
> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -167,7 +167,8 @@ static int ieee80211_key_enable_hw_accel(struct 
> ieee80211_key *key)
>                  * The driver doesn't know anything about VLAN 
> interfaces.
>                  * Hence, don't send GTKs for VLAN interfaces to the 
> driver.
>                  */
> -               if (!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE))
> +               if ((!(key->conf.flags & IEEE80211_KEY_FLAG_PAIRWISE) &&
> +                   !ieee80211_hw_check(&key->local->hw, 
> SW_CRYPTO_CONTROL)))
>                         goto out_unsupported;
>         }
>
> Please let me know which is the better way to deal the problem.
>
> Thanks,
> Manikanta
>
>
> On 2018-04-24 14:39, Sebastian Gottschall wrote:
>> consider my comment regarding vlan_ap.
>> this patch will break wds ap / wds sta support with latest mac80211
>> (see also my post on the wireless mailing list about the breaking
>> patch in mac80211)
>> so AP_VLAN must be masked always for all chipsets. otherwise wds
>> breaks and this is not just a guess. i tested it yesterday using this
>> patch and found
>> the cause of the issue
>>
>> the following lines
>>
>>   +    if (test_bit(WMI_SERVICE_PER_PACKET_SW_ENCRYPT, 
>> ar->wmi.svc_map)) {
>> +        ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
>> +        ar->hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
>> +    }
>>
>>
>> must be just
>>
>> +        ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_AP_VLAN);
>> +        ar->hw->wiphy->software_iftypes |= BIT(NL80211_IFTYPE_AP_VLAN);
>>
>> everthing else will cause a regression
>>
>> Am 24.04.2018 um 10:09 schrieb Kalle Valo:
>>> Manikanta Pubbisetty <mpubbise@codeaurora.org> writes:
>>>
>>>> Mutlicast/broadcast traffic destined for a particular vlan group will
>>>> always be encrypted in software. To enable dynamic VLANs, it requires
>>>> driver support for sending software encrypted packets.
>>>>
>>>> In ath10k, sending sw encrypted frames is allowed only when we insmod
>>>> the driver with cryptmode param set to 1, this configuration disables
>>>> hardware crypto and enables RAW mode implicitly. Since, enabling raw
>>>> mode has performance impact, this cannot be considered as an ideal
>>>> solution for supporting VLANs in the driver.
>>>>
>>>> As an alternative take, in this approach, cryptographic keys for
>>>> unicast traffic(per peer PTKs) and keys for non-vlan group traffic
>>>> will be configured in hardware, allowing hardware encryption for 
>>>> unicast
>>>> and non-vlan group traffic. Only vlan group traffic will be 
>>>> encrypted in
>>>> software and pushed to the target with encap mode set to RAW in the TX
>>>> descriptors.
>>>>
>>>> Not all firmwares can support this type of key configuration(having 
>>>> few
>>>> keys installed in hardware and few only in software); for this 
>>>> purpose a
>>>> new WMI service flag "WMI_SERVICE_PER_PACKET_SW_ENCRYPT" is 
>>>> introduced to
>>>> advertise this support.
>>>>
>>>> Also, adding the logic required to send sw encrypted frames in raw 
>>>> mode.
>>>>
>>>> Tested this change on QCA9984(firmware version 10.4-3.5.3-00057).
>>>>
>>>> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
>>> Your name in patchwork is wrong and hence my script uses the wrong
>>> name. Please fix it by registering to patchwork[1] where it's possible
>>> to change your name during registration, but only one time. If that
>>> doesn't work then send a request to helpdesk@kernel.org and the admins
>>> can fix it.
>>>
>>> [1] https://patchwork.kernel.org/register/
>>>
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
