Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:49081 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753045Ab3LPMFe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 07:05:34 -0500
Received: by mail-ig0-f172.google.com with SMTP id hl1so3614474igb.5
        for <linux-wireless@vger.kernel.org>; Mon, 16 Dec 2013 04:05:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>
References: <CANq1E4R--OowH-LCUX4oSxsJu7yf_2e6Jei8tP+i_BQ_QHiKkw@mail.gmail.com>
Date: Mon, 16 Dec 2013 13:00:22 +0100
Message-ID: <CANq1E4QbUF0gde=L5-GDc5+GYUYv7xsinC7Xs0Q5_ovk_YPaSA@mail.gmail.com> (sfid-20131216_130538_912464_72356004)
Subject: Re: [BUG] P2P setup timeout
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Anyone with ideas? Or hints whether it's driver or wpa_supplicant related?

Thanks
David

On Fri, Dec 6, 2013 at 11:18 AM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> I am currently working on user-space helpers for P2P setup as part of
> an Open-Source Miracast implementation (openwfd). I can set up a
> P2P-group with my Android test-device just fine, however, it only
> works if initiated by the GNU/Linux host. Once I initiate the
> p2p-connect from the Android device, it creates a group and sends me a
> p2p-invitation which I am unable to accept.
>
> I am running wpa_supplicant-git from today (but also tried older
> versions), ath9k-htc from linus-git (3.13-rc2) and the relevant log
> files are appended.
>
> My wpa-config is:
>   ctrl_interface=/var/run/wpa_supplicant
>   update_config=1
>   p2p_go_ht40=1
>
> And I do nothing else than open wpa_cli and run:
>   p2p_find
>   p2p_connect <peer> pbc
>
> This works perfectly well if I don't touch the Android device before
> issuing the p2p_connect. However, if I initiate the first connect on
> the Android device, my linux host gets a p2p-invitation:
>   <3>P2P-INVITATION-RECEIVED sa=12:68:3f:4e:39:f2
> go_dev_addr=12:68:3f:4e:39:f2 bssid=12:68:3f:4e:b9:f2 unknown-network
>
> I tried accepting this invitation via p2p_connect, but just nothing
> happens. I also tried any combination of arguments
> (auth/join/persistent, pbc/pin/PIN#, playing with go_intent=), didn't
> help..
>
> Looking at the wpa-log, I see a timeout firing repeatedly:
>   P2P: GO Negotiation Request TX callback: success=1
>   P2P: State CONNECT -> CONNECT
>   P2P: Set timeout (state=CONNECT): 0.500000 sec
>   P2P: Timeout (state=CONNECT)
> Below you can see the whole sequence of wpa-messages that repeat over
> and over again until I cancel the connection-request.
>
> For WFD I need to initiate the connect from the Android device,
> otherwise their WFD stack won't recognize the connection. So if anyone
> has hints what might be wrong here, I'd gladly try out any patches or
> configurations.
> I cannot test whether this happens with other drivers, too, as I
> couldn't get my hands on a device other than ath9k-htc which supports
> p2p on linux.
>
> If anyone is interested, I'll be presenting OpenWFD at FOSDEM in the
> graphics-devroom. It would be awesome if I can get my Nexus-4 as a
> working demo until then. Otherwise, it'll be just linux<->linux demos
> (non-android), which is already working fine.
>
> Any hints welcome!
> David
>
>
> The repeating log-messages from wpa-supplicant are (see attached file
> for the whole log):
>
> Off-channel: Action frame sequence done notification
> nl80211: Cancel TX frame wait: cookie=0xffff88008fddae00
> nl80211: wait cancel failed: ret=-2 (No such file or directory)
> P2P: State CONNECT -> CONNECT_LISTEN
> P2P: Starting short listen state (state=CONNECT_LISTEN)
> WPS:  * Version (hardcoded 0x10)
> P2P: WPS IE Device Password ID: 4
> WPS:  * UUID-E
> P2P: * P2P IE header
> P2P: * Capability dev=25 group=00
> P2P: * Device Info
> nl80211: Probe Request reporting already on!
> nl_preq=0x888888888ab37c09
> nl80211: Remain-on-channel cookie 0xa7 for freq=2437 MHz duration=204
> nl80211: Drv Event 55 (NL80211_CMD_REMAIN_ON_CHANNEL) received for wlan1
> nl80211: Remain-on-channel event (cancel=0 freq=2437 channel_type=0
> duration=204 cookie=0xa7 (match))
> wlan1: Event REMAIN_ON_CHANNEL (22) received
> Off-channel: Send Action callback (without_roc=0
> pending_action_tx=(nil))
> P2P: Starting Listen timeout(0,204800) on freq=2437 based on callback
> P2P: Set timeout (state=CONNECT_LISTEN): 0.224800 sec
> nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
> for wlan1
> nl80211: Remain-on-channel event (cancel=1 freq=2437 channel_type=0
> duration=0 cookie=0xa7 (match))
> wlan1: Event CANCEL_REMAIN_ON_CHANNEL (23) received
> P2P: Cancel remain-on-channel callback (p2p_long_listen=0 ms
> pending_action_tx=(nil))
> P2P: Driver ended Listen state (freq=2437)
> P2P: Skip stop_listen since not in listen_only state.
> P2P: Timeout (state=CONNECT_LISTEN)
> P2P: State CONNECT_LISTEN -> CONNECT
> P2P: * Dialog Token: 1
> P2P: * P2P IE header
> P2P: * Capability dev=25 group=08
> P2P: * GO Intent: Intent 7 Tie breaker 0
> P2P: * Configuration Timeout: GO 255 (*10ms)  client 20 (*10ms)
> P2P: * Listen Channel: Regulatory Class 81 Channel 6
> P2P: * Intended P2P Interface Address 12:6f:3f:7a:7c:24
> P2P: * Channel List - hexdump(len=16): 58 58 04 51 0b 01 02 03 04 05
> 06 07 08 09 0a 0b
> P2P: * Device Info
> P2P: * Operating Channel: Regulatory Class 81 Channel 6
> WPS:  * Version (hardcoded 0x10)
> P2P: WPS IE Device Password ID: 4
> P2P: Sending GO Negotiation Request
> P2P: State CONNECT -> CONNECT
> Off-channel: Send action frame: freq=2437 dst=12:68:3f:4e:39:f2
> src=10:6f:3f:7a:7c:24 bssid=12:68:3f:4e:39:f2 len=113
> nl80211: Send Action frame (ifindex=14, freq=2437 MHz wait=500 ms
> no_cck=1)
> nl80211: Drv Event 60 (NL80211_CMD_FRAME_TX_STATUS) received for wlan1
> nl80211: Frame TX status event
> nl80211: Action TX status: cookie=0ffff88008fddb100 (match) (ack=1)
> wlan1: Event TX_STATUS (18) received
> wlan1: EVENT_TX_STATUS dst=12:68:3f:4e:39:f2 type=0 stype=13
> Off-channel: Delete matching pending action frame
> Off-channel: TX status result=0 cb=0x42eaf0
> P2P: Action frame TX callback (state=1 freq=2437 dst=12:68:3f:4e:39:f2
> src=10:6f:3f:7a:7c:24 bssid=12:68:3f:4e:39:f2 result=0
> P2P: GO Negotiation Request TX callback: success=1
> P2P: State CONNECT -> CONNECT
> P2P: Set timeout (state=CONNECT): 0.500000 sec
> P2P: Timeout (state=CONNECT)
> Off-channel: Action frame sequence done notification
>
>
> wpa_cli log/interaction is this:
>
> wpa_cli v2.1-devel
> Copyright (c) 2004-2013, Jouni Malinen <j@w1.fi> and contributors
>
> This software may be distributed under the terms of the BSD license.
> See README for more details.
>
> Interactive mode
>
>> p2p_find
> OK
> <3>P2P-DEVICE-FOUND 12:68:3f:4e:39:f2 p2p_dev_addr=12:68:3f:4e:39:f2
> pri_dev_type=10-0050F204-5 name='dvdhrm-nx' config_methods=0x188
> dev_capab=0x25 group_capab=0x0
> <3>P2P-INVITATION-RECEIVED sa=12:68:3f:4e:39:f2
> go_dev_addr=12:68:3f:4e:39:f2 bssid=12:68:3f:4e:b9:f2 unknown-network
>> p2p_connect 12:68:3f:4e:39:f2 pbc
> OK
> <3>P2P-FIND-STOPPED
