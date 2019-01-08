Return-Path: <SRS0=f1+T=PQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48F52C43387
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 23:27:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F36C120665
	for <linux-wireless@archiver.kernel.org>; Tue,  8 Jan 2019 23:27:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="deFxIWJN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728913AbfAHX1B (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 8 Jan 2019 18:27:01 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:43582 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728402AbfAHX1B (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 8 Jan 2019 18:27:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2014; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=lCtvijgqmKarjbhdMkyDfpv4695DkH1SbLrgnUjJoTM=; b=deFxIWJNK/GuUMkHBg7W/lw53
        mko/a8Ql+lb1FB1akThIWMmd/+q/j9twsx2xu8zoSW5+eGKHlYUq7Z1Telot8V65Uv3gpd1s+x+jI
        UUpZCEV5a/yPNTYqQRmwLqB/VIEqjQlpKkCSd9xCHbIhuAl+v7x2wL15NHrsItOyiT4K4=;
Received: from n2100.armlinux.org.uk ([fd8f:7570:feb6:1:214:fdff:fe10:4f86]:38742)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1gh0ln-0004vW-0E; Tue, 08 Jan 2019 23:26:51 +0000
Received: from linux by n2100.armlinux.org.uk with local (Exim 4.90_1)
        (envelope-from <linux@n2100.armlinux.org.uk>)
        id 1gh0lk-0007XP-8A; Tue, 08 Jan 2019 23:26:48 +0000
Date:   Tue, 8 Jan 2019 23:26:46 +0000
From:   Russell King - ARM Linux <linux@armlinux.org.uk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend Van Spriel <arend.vanspriel@broadcom.com>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
Message-ID: <20190108232646.GV11171@n2100.armlinux.org.uk>
References: <20181224110925.GY26090@n2100.armlinux.org.uk>
 <CAF7Mx6r_q7H4ioFLoF1eKHrvmtE0xViG__uDNByaNjrGGJWx+Q@mail.gmail.com>
 <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 08, 2019 at 06:40:46PM +0200, Kalle Valo wrote:
> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
> 
> > Response using Gmail on phone
> 
> Unfortunately it had HTML and not sure if it made it to the list, so
> copying your response in full below just in case. Russell, does the
> commit below fix your problem?
> 
> 861cb5eb467f brcmfmac: Fix access point mode

From a quick test this evening, it does seem to allow brcmfmac to work
with hostapd again, which is good news.

However, I've been seeing other issues with the brcmfmac over the course
of the last week, which needs the brcmfmac module to be removed and
re-loaded to rescue the situation - ultimately, it means that running
brcmfmac in host AP mode is unreliable.  This is with 4.19 and my
patch - we will see how 4.20 with the above mentioned patch behaves over
the coming week.

[1036107.225569] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1036108.217519] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1043906.813243] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1043907.809184] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1044220.587626] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
[1045006.357728] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
[1049743.889412] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
[1061305.953430] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1061308.641378] brcmfmac: send_key_to_dongle: wsec_key error (-110)
[1061309.665234] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1061312.993053] brcmfmac: brcmf_cfg80211_change_station: Setting SCB (de-)authorize failed, -110

Then I'd reload the module and reconfigure the networking:

[1078473.212335] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[1078473.222473] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[1078473.230066] brcmfmac: brcmf_cfg80211_get_channel: chanspec failed (-5)
[1078473.423466] brcmfmac: F1 signature read @0x18000000=0x16044330
[1078473.448873] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4330-sdio
for chip BCM4330/4
[1078473.794979] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4330-sdio
for chip BCM4330/4
[1078473.804750] brcmfmac mmc0:0001:1: Direct firmware load for brcm/brcmfmac4330-sdio.clm_blob failed with error -2
[1078473.817127] brcmfmac: brcmf_c_process_clm_blob: no clm_blob available (err=-2), device may have limited channels available
[1078473.831682] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4330/4 wl0: Oct 25 2011 19:34:12 version 5.90.125.104
[1078474.107922] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1078474.229331] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1078474.782310] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1078476.471994] brcmfmac: brcmf_p2p_create_p2pdev: timeout occurred
[1078476.478270] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlan0 type 10 failed: err=-5
[1078476.512507] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1078478.091188] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1078478.139786] netlink: 'wpa_supplicant': attribute type 213 has an invalid length.
[1078478.349878] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[1078478.837386] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
[1078478.848627] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
[1078478.906905] netlink: 'wpa_supplicant': attribute type 213 has an invalid length.
[1078484.468666] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
[1078484.479804] brcmfmac: brcmf_vif_set_mgmt_ie: vndr ie set error : -52
[1078485.038287] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1078485.398249] br0: port 2(wlan0) entered blocking state
[1078485.403675] br0: port 2(wlan0) entered forwarding state
[1127330.284075] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
[1133420.775451] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
[1148684.418698] brcmfmac: send_key_to_dongle: wsec_key error (-110)

... reloading again ...

[1163361.156133] br0: port 2(wlan0) entered disabled state
[1163361.245369] device wlan0 left promiscuous mode
[1163361.250437] br0: port 2(wlan0) entered disabled state
[1163361.285328] brcmfmac: brcmf_cfg80211_change_iface: WLC_SET_INFRA error (-5)[1163361.293839] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[1163361.301738] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[1163361.309439] brcmfmac: brcmf_cfg80211_get_channel: chanspec failed (-5)
[1163361.317291] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[1163361.324788] brcmfmac: brcmf_cfg80211_get_channel: chanspec failed (-5)
[1163361.333679] brcmfmac: brcmf_fil_cmd_data: bus is down. we have nothing to do.
[1163361.341189] brcmfmac: brcmf_cfg80211_get_channel: chanspec failed (-5)
[1163361.529825] brcmfmac: F1 signature read @0x18000000=0x16044330
[1163361.547495] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4330-sdio for chip BCM4330/4
[1163361.894540] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4330-sdio for chip BCM4330/4
[1163361.903540] brcmfmac mmc0:0001:1: Direct firmware load for brcm/brcmfmac4330-sdio.clm_blob failed with error -2
[1163361.914067] brcmfmac: brcmf_c_process_clm_blob: no clm_blob available (err=-2), device may have limited channels available
[1163361.930371] brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4330/4 wl0: Oct 25 2011 19:34:12 version 5.90.125.104
[1163362.173752] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1163362.295305] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1163362.862063] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1163364.576933] brcmfmac: brcmf_p2p_create_p2pdev: timeout occurred
[1163364.583207] brcmfmac: brcmf_cfg80211_add_iface: add iface p2p-dev-wlan0 type 10 failed: err=-5
[1163365.139274] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[1163365.170973] br0: port 2(wlan0) entered blocking state
[1163365.176371] br0: port 2(wlan0) entered disabled state
[1163365.184962] device wlan0 entered promiscuous mode
[1163365.469716] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[1163365.480003] br0: port 2(wlan0) entered blocking state
[1163365.485371] br0: port 2(wlan0) entered forwarding state
[1242693.543254] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
[1242696.102911] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
[1242696.111775] brcmfmac: brcmf_cfg80211_get_station: GET STA INFO failed, -110
[1331361.789147] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1331362.779876] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1331958.234110] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1332559.191969] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1333160.149868] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1333761.111701] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1334362.065533] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[1334963.023362] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets

Any thoughts on what would cause this?

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
