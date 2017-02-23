Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37246 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbdBWKmm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 05:42:42 -0500
Received: by mail-wm0-f54.google.com with SMTP id v77so7592338wmv.0
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 02:42:41 -0800 (PST)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
To: Jithu Jance <jithu.jance@broadcom.com>
References: <20170221100957.30965-1-johannes@sipsolutions.net>
 <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
 <1487673603.2215.3.camel@sipsolutions.net>
 <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
 <1487680651.2215.5.camel@sipsolutions.net>
 <3fa1e3ac-5722-c46d-acc1-62407f4eef07@broadcom.com>
 <CA+gyVQ11yZjkJXjiVoMVijs=_K8itZMQrces9XQha_bT4=H-DA@mail.gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Jouni Malinen <j@w1.fi>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <9b6de09f-d872-fd67-971a-6da369fefe1a@broadcom.com> (sfid-20170223_114306_832288_B79D82AF)
Date: Thu, 23 Feb 2017 11:36:30 +0100
MIME-Version: 1.0
In-Reply-To: <CA+gyVQ11yZjkJXjiVoMVijs=_K8itZMQrces9XQha_bT4=H-DA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22-2-2017 13:24, Jithu Jance wrote:
> Hi Jouni, Johannes et al.,
> 
> On Wed, Feb 22, 2017 at 1:27 AM, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 21-2-2017 13:37, Johannes Berg wrote:
>>>
>>>> What I am also missing is how to deal with NL80211_CMD_CONNECTED
>>>> event signalling. Should that be given after (un)successful
>>>> completion of the 4-way handshake or should we have a separate event
>>>> for that?
>>>
>>> That's a good point. I don't think a new event really works well, but
>>> perhaps we should extend the NL80211_TIMEOUT_* values with this? It's
>>> not strictly a timeout, I guess, but it's not a direct rejection of the
>>> association either.
>>>
>>> Any thoughts?
>>
>> I discussed about the event mechanism with Jithu which is who asked me
>> to look at their patches for this feature. His suggestion was to have a
>> "port authorized" event after successful handshake as it will help in
>> key mgmt offload cases. He gave the following example: Suppose you are
>> doing a fresh 8021x followed by 4way handshake offload. Right now there
>> is no event to indicate to the upper layer that the 4way handshake have
>> been completed successfully. So the only thing to do in wpa_supplicant
>> is to consider it completed and if not be hit with deauth.
> 
> In wpa_supplicant terms, I was looking for an event notification to move the
> wpa_state from WPA_ASSOCIATED to WPA_COMPLETED.  :)

Currently in wpa_supplicant_event_assoc() the 4-way handshake offload is
handled as below:

        if ((wpa_s->drv_flags & WPA_DRIVER_FLAGS_4WAY_HANDSHAKE) &&
            wpa_key_mgmt_wpa_psk(wpa_s->key_mgmt)) {
                /*
                 * We are done; the driver will take care of RSN 4-way
                 * handshake.
                 */
                wpa_supplicant_cancel_auth_timeout(wpa_s);
                wpa_supplicant_set_state(wpa_s, WPA_COMPLETED);
                eapol_sm_notify_portValid(wpa_s->eapol, TRUE);
                eapol_sm_notify_eap_success(wpa_s->eapol, TRUE);
        } else if ((wpa_s->drv_flags & WPA_DRIVER_FLAGS_4WAY_HANDSHAKE) &&
                   wpa_key_mgmt_wpa_ieee8021x(wpa_s->key_mgmt)) {
                /*
                 * The driver will take care of RSN 4-way handshake, so
we need
                 * to allow EAPOL supplicant to complete its work without
                 * waiting for WPA supplicant.
                 */
                eapol_sm_notify_portValid(wpa_s->eapol, TRUE);
        } else if (ft_completed) {

So for 4-way hs offload for wpa/wpa2-psk it already calls
eapol_sm_notify_eap_success() and reading the documentation of that
function:

/**
 * eapol_sm_notify_eap_success - Notification of external EAP success
trigger
 * @sm: Pointer to EAPOL state machine allocated with eapol_sm_init()
 * @success: %TRUE = set success, %FALSE = clear success
 *
 * Notify the EAPOL state machine that external event has forced EAP
state to
 * success (success = %TRUE). This can be cleared by setting success =
%FALSE.
 *
 * This function is called to update EAP state when WPA-PSK key
handshake has
 * been completed successfully since WPA-PSK does not use EAP state machine.
 */
void eapol_sm_notify_eap_success(struct eapol_sm *sm, Boolean success)

So the code in wpa_supplicant_event_assoc() is either lying or the assoc
event should come after driver has completed successfully. To me it
seems worth it to have NL80211_CMD_EAP_COMPLETED event carrying the
result or indeed give the CONNECTED event later in the driver.

Regards,
Arend
