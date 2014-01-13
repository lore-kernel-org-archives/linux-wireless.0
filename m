Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:62287 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbaAMLfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 06:35:10 -0500
Received: by mail-ie0-f176.google.com with SMTP id lx4so897628iec.35
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 03:35:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANq1E4Rhja6XZPq9sXfycK_wWNB3nsjpQFr2XnzOXLHUnm__mw@mail.gmail.com>
References: <CANq1E4Rhja6XZPq9sXfycK_wWNB3nsjpQFr2XnzOXLHUnm__mw@mail.gmail.com>
Date: Mon, 13 Jan 2014 12:35:09 +0100
Message-ID: <CANq1E4STKqci55ZbGP9Siorf3ABptHHTAuOg_4-bbbEiw93w+A@mail.gmail.com> (sfid-20140113_123518_262928_846EEF2D)
Subject: Re: iwlwifi: P2P group-formation timeout
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

Does anyone have an idea where to look into for that?

Thanks
David

On Tue, Jan 7, 2014 at 3:37 PM, David Herrmann <dh.herrmann@gmail.com> wrote:
> Hi
>
> Given that ath9k-htc and rtl8088 lack firmware features, I'm now on
> iwlwifi-7260. As it uses P2P_DEVICE, I'm a little bit confused how to
> get it working. I'm running wpa_supplicant-git from today,
> linux-3.13-rc7 both with new and old mvm firmware (<=22.15.8.0).
> However, I haven't been able to get *any* p2p-connection working with
> my Android Nexus 4 device.
>
> I run wpa_supplicant as:
>   wpa_supplicant -d -Dnl80211 -c wpa.conf -i wlan0 -p
> p2p_device=1,use_p2p_group_interface=1
>
> My wpa.conf is:
>   ctrl_interface=/run/wpa_supplicant
>   ap_scan=1
>   p2p_go_ht40=1
>   device_name=david-ub
>   device_type=1-0050F204-1
>
> In wpa_cli I run:
>   p2p_find
>   p2p_connect 12:68:3f:4e:39:f2 pbc
>
> On the remote Android device, I get the pbc-button-notification which
> I simply accept. The go-negotiation succeeds but the group-formation
> times out.
>
> wpa.log is appended. kernel-log has no information on iwlwifi other than:
>
> [    3.282831] iwlwifi 0000:01:00.0: enabling device (0000 -> 0002)
> [    3.283670] iwlwifi 0000:01:00.0: irq 43 for MSI/MSI-X
> [    3.297821] iwlwifi 0000:01:00.0: loaded firmware version 22.15.8.0
> op_mode iwlmvm
> [    3.316875] iwlwifi 0000:01:00.0: Detected Intel(R) Dual Band
> Wireless AC 7260, REV=0x144
> [    3.317452] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [    3.318290] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> ...
> [   95.379965] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   95.380215] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [   95.393749] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  326.788182] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [  326.788400] iwlwifi 0000:01:00.0: L1 Enabled; Disabling L0S
> [  326.802291] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
> [  360.049401] IPv6: ADDRCONF(NETDEV_UP): p2p-wlan0-0: link is not ready
> [  360.083079] IPv6: ADDRCONF(NETDEV_CHANGE): p2p-wlan0-0: link becomes ready
>
> Lemme know if iwlwifi-debug options should be enabled and I can
> provide a full debug log.
> There are a bunch of errors in the wpa_supplicant log during startup,
> but I think they're related to nl80211+P2P_DEVICE and expected?
> These include:
>   Could not read interface p2p-dev-wlan0 flags: No such device
>   nl80211: Use separate P2P group interface (driver advertised support)
>   nl80211: interface p2p-dev-wlan0 in phy phy0
>   nl80211: Set mode ifindex 0 iftype 10 (P2P_DEVICE)
>   nl80211: Failed to set interface 0 to mode 10: -22 (Invalid argument)
>
> The GO-negotiation itself succeeds. However, the following
> group-formation fails, the relevant part of the log is probably this:
>
> P2P-GO-NEG-SUCCESS role=GO freq=5180 ht40=0 peer_dev=12:68:3f:4e:39:f2
> peer_iface=12:68:3f:4e:b9:f2 wps_method=PBC
> p2p-dev-wlan0: P2P: Starting GO
> p2p-dev-wlan0: P2P: Request scan (that will be skipped) to start GO)
> p2p-dev-wlan0: Setting scan request: 0.000000 sec
> p2p-dev-wlan0: State: DISCONNECTED -> SCANNING
> Start a pre-selected network without scan step
> Setting up AP (SSID='DIRECT-EM')
> nl80211: Setup AP operations for P2P group (GO)
> nl80211: Set mode ifindex 0 iftype 9 (P2P_GO)
> nl80211: Failed to set interface 0 to mode 9: -22 (Invalid argument)
> nl80211: Try mode change after setting interface down
> nl80211: Stop P2P Device p2p-dev-wlan0 (0x2): Success
> nl80211: Set mode ifindex 0 iftype 9 (P2P_GO)
> nl80211: Failed to set interface 0 to mode 9: -22 (Invalid argument)
> nl80211: Start P2P Device p2p-dev-wlan0 (0x2): Success
> nl80211: Interface mode change to 9 from 10 failed
> nl80211: Remove monitor interface: refcount=0
> p2p-dev-wlan0: Failed to start AP functionality
> p2p-dev-wlan0: State: SCANNING -> DISCONNECTED
> nl80211: Set p2p-dev-wlan0 operstate 0->0 (DORMANT)
> netlink: Operstate: ifindex=0 linkmode=-1 (no change), operstate=5
> (IF_OPER_DORMANT)
> nl80211: Drv Event 56 (NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL) received
> for p2p-dev-wlan0
> nl80211: Remain-on-channel event (cancel=1 freq=2462 channel_type=0
> duration=0 cookie=0x3e (match))
> p2p-dev-wlan0: Event CANCEL_REMAIN_ON_CHANNEL (22) received
> P2P: Cancel remain-on-channel callback (p2p_long_listen=0 ms
> pending_action_tx=(nil))
> p2p-dev-wlan0: Radio work 'p2p-listen'@0x1e930e0 done in 0.090383 seconds
> P2P: Driver ended Listen state (freq=2462)
> P2P: Skip stop_listen since not in listen_only state.
> P2P: Group Formation timed out
> P2P: Group Formation failed with 12:68:3f:4e:b9:f2
> P2P: Clear timeout (state=PROVISIONING)
> P2P: State PROVISIONING -> IDLE
> P2P-GROUP-FORMATION-FAILURE
>
>
> Any hints are welcome. If there's any debug-option I should enable to
> provide more logs, lemme know. I can also give iwlwifi-next a try if
> there're any important patches pending. The p2p-dev-wlan0 related
> errors are quite confusing, but I think they're caused by the fact
> that there's no netdev for the device. At least I only have wlan0 and
> p2p-wlan0-0 during runtime, a p2p-dev-wlan0 never shows up.
>
> Thanks
> David
