Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36608 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933013AbcJERp5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 13:45:57 -0400
Received: by mail-wm0-f50.google.com with SMTP id k125so280951130wma.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2016 10:45:56 -0700 (PDT)
MIME-Version: 1.0
From: Daniel Drake <drake@endlessm.com>
Date: Wed, 5 Oct 2016 11:45:55 -0600
Message-ID: <CAD8Lp44ZMgEijQ3QdZCf=mAXmuV5F4_eMD=AKod8ps-h8X_2xQ@mail.gmail.com> (sfid-20161005_194605_967030_B81949D1)
Subject: ath9k excessive delay in handling EAPOL frames
To: linux-wireless@vger.kernel.org
Cc: Linux Upstreaming Team <linux@endlessm.com>,
        ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

As this is remote problem debugging I haven't gathered quite as much
info as I would like, and won't be investigating further immediately,
but I would like to share what I have found so far, maybe it is useful
knowledge and we can revisit later.

With the following hardware on Linux 4.4, we cannot connect to our
office WPA2-PSK network. Other networks seem fine.

02:00.0 Network controller [0280]: Qualcomm Atheros QCA9565 / AR9565
Wireless Network Adapter [168c:0036] (rev 01)
Subsystem: AzureWave Device [1a3b:218d]
Kernel driver in use: ath9k

The logs show:

wpa_supplicant[585]: wlp2s0: SME: Trying to authenticate with
0c:11:67:33:8d:50 (SSID='Endless' freq=2457 MHz)
kernel: wlp2s0: authenticate with 0c:11:67:33:8d:50
NetworkManager[620]: <info> [1474483556.0677] device (wlp2s0):
supplicant interface state: inactive -> authenticating
kernel: wlp2s0: send auth to 0c:11:67:33:8d:50 (try 1/3)
kernel: wlp2s0: send auth to 0c:11:67:33:8d:50 (try 2/3)
kernel: wlp2s0: send auth to 0c:11:67:33:8d:50 (try 3/3)
wpa_supplicant[585]: wlp2s0: Trying to associate with
0c:11:67:33:8d:50 (SSID='Endless' freq=2457 MHz)
kernel: wlp2s0: authenticated
NetworkManager[620]: <info> [1474483558.1078] device (wlp2s0):
supplicant interface state: authenticating -> associating
kernel: wlp2s0: associate with 0c:11:67:33:8d:50 (try 1/3)
kernel: wlp2s0: associate with 0c:11:67:33:8d:50 (try 2/3)
kernel: wlp2s0: associate with 0c:11:67:33:8d:50 (try 3/3)
wpa_supplicant[585]: wlp2s0: Associated with 0c:11:67:33:8d:50
kernel: wlp2s0: RX AssocResp from 0c:11:67:33:8d:50 (capab=0x431 status=0 aid=5)
kernel: wlp2s0: associated
kernel: wlp2s0: deauthenticated from 0c:11:67:33:8d:50 (Reason:
23=IEEE8021X_FAILED)

Using monitor mode from another station, I observe:

- STA sends association request
- AP sends association response 0.01s later, STA acks
- AP sends EAPOL 0.002s later, STA acks
- AP sends another EAPOL 0.1s later, STA acks
- AP sends deauthentication 0.3s later (presumably a timeout waiting
for EAPOL response), STA acks
- STA sends another association request 0.5s later
- AP replies with Deauthentication (can't associated as you are deauthed)
- STA sends another association request 1s later
- AP replies with Deauthentication again
- STA sends EAPOL response message, a full 2 seconds after the first
EAPOL was received

It is as if the processing of incoming frames is getting stuck for 2
seconds, even though they were already ACKed. i.e. The first
association requests succeeds immediately but the processing of the
AssocResp frame (and the following EAPOLs and deauth) is delayed by
more than 2 seconds, far longer than the AP is willing to wait.

I have confirmed this perspective in the wpa_supplicant debug logs
too, there is 2 seconds of RX silence after the first association
request is sent before all the frames come in at once.

Hope this partial info is useful in some way, I'll come back to this
problem as time permits.

Daniel
