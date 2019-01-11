Return-Path: <SRS0=8fZi=PT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1DBC43387
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:11:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F0E520874
	for <linux-wireless@archiver.kernel.org>; Fri, 11 Jan 2019 15:11:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=armlinux.org.uk header.i=@armlinux.org.uk header.b="gGamytnt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387533AbfAKOQB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 11 Jan 2019 09:16:01 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58248 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387495AbfAKOQB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Jan 2019 09:16:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2014; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=uqpdpQIYU+DTMR4wxxZnSfqJrO83OylqpYQgb4JjonA=; b=gGamytntk4LLwyMPIIs1LI0Je
        bx7nzemGsweH+4dclL+ucWX2ZjbtxsvQ6xZclxfeAP+RmWAO67AhOvgYTauZN8EmNSM3dNB/+Dj0t
        pNLdK4klPLAzVry7pHivdTOQUyyY+LXHjsxwvHx0Q8SkXhY1JlcmqzZtP8xGfUGEUsh2o=;
Received: from n2100.armlinux.org.uk ([2001:4d48:ad52:3201:214:fdff:fe10:4f86]:50458)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES128-GCM-SHA256:128)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ghxbD-0005RE-Ll; Fri, 11 Jan 2019 14:15:51 +0000
Received: from linux by n2100.armlinux.org.uk with local (Exim 4.90_1)
        (envelope-from <linux@n2100.armlinux.org.uk>)
        id 1ghxbB-0002la-5h; Fri, 11 Jan 2019 14:15:49 +0000
Date:   Fri, 11 Jan 2019 14:15:47 +0000
From:   Russell King - ARM Linux <linux@armlinux.org.uk>
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        linux-wireless@vger.kernel.org, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        wright.feng@cypress.com, brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com
Subject: Re: [REGRESSION] hostapd 2.4..2.7 broken with 4.18+
Message-ID: <20190111141543.GA2392@n2100.armlinux.org.uk>
References: <20181224110925.GY26090@n2100.armlinux.org.uk>
 <CAF7Mx6r_q7H4ioFLoF1eKHrvmtE0xViG__uDNByaNjrGGJWx+Q@mail.gmail.com>
 <874lajrtkh.fsf@kamboji.qca.qualcomm.com>
 <20190108232646.GV11171@n2100.armlinux.org.uk>
 <30039f89-6adb-c08e-1796-553e578b250f@broadcom.com>
 <20190109105622.GY11171@n2100.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190109105622.GY11171@n2100.armlinux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Jan 09, 2019 at 10:56:22AM +0000, Russell King - ARM Linux wrote:
> On Wed, Jan 09, 2019 at 11:27:31AM +0100, Arend Van Spriel wrote:
> > On 1/9/2019 12:26 AM, Russell King - ARM Linux wrote:
> > >On Tue, Jan 08, 2019 at 06:40:46PM +0200, Kalle Valo wrote:
> > >>Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
> > >>
> > >>>Response using Gmail on phone
> > >>
> > >>Unfortunately it had HTML and not sure if it made it to the list, so
> > >>copying your response in full below just in case. Russell, does the
> > >>commit below fix your problem?
> > >>
> > >>861cb5eb467f brcmfmac: Fix access point mode
> > >
> > > From a quick test this evening, it does seem to allow brcmfmac to work
> > >with hostapd again, which is good news.
> > >
> > >However, I've been seeing other issues with the brcmfmac over the course
> > >of the last week, which needs the brcmfmac module to be removed and
> > >re-loaded to rescue the situation - ultimately, it means that running
> > >brcmfmac in host AP mode is unreliable.  This is with 4.19 and my
> > >patch - we will see how 4.20 with the above mentioned patch behaves over
> > >the coming week.
> > >
> > >[1036107.225569] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> > >[1036108.217519] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> > >[1043906.813243] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> > >[1043907.809184] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> > >[1044220.587626] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
> > >[1045006.357728] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> > >[1049743.889412] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
> > >[1061305.953430] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> > >[1061308.641378] brcmfmac: send_key_to_dongle: wsec_key error (-110)
> > >[1061309.665234] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
> > >[1061312.993053] brcmfmac: brcmf_cfg80211_change_station: Setting SCB (de-)authorize failed, -110
> > 
> > Is this with hostapd? If so, this br0 message suggest you let hostapd create
> > a bridge, is that correct? Just trying to get a good picture in case I want
> > to replicate things over here although I am pretty sure I do not have the
> > same platform lying around here. Although, what platform do you have?
> 
> Yes, it's with hostapd.  With the nl80211 driver, hostapd will only add
> the device to a bridge, rather than creating the bridge itself.
> 
> I'm using Debian Stretch, and my /etc/network/interfaces contains:
> 
> iface br0 inet manual
>         bridge-ports eth0.nnn
>         bridge-maxwait 0
> 
> iface eth0.224 inet manual
> 
> iface wlan0 inet manual
>         pre-up nmcli d set wlan0 managed no
>         hostapd /etc/hostapd/rmk-home.conf
> 
> and these are scripted to be brought up in the order: eth0.224, then
> br0, then wlan0.
> 
> These are iMX6 Hummingboards - one is a Hummingboard2, the other is
> a Hummingboard.  Both have the 4330 device on, and both are running
> the same firmware.
> 
> > The timeout (-110) error can mean either firmware crashed or the sdio host
> > controller went in limbo. If this happens again on 4.20 (or 5.0-rc1), you
> > could build the driver with CONFIG_BRCMDBG and load the driver with
> > debug=0x100010. If it is a firmware crash it should show up in the log.
> 
> Interestingly, I've just checked another Hummingboard2 running in
> hostapd mode (with a 4.13 kernel) which had been up for over a year
> until I recently did some maintenance on it.  It has a later firmware
> and hasn't shown a problem.
> 
> brcmfmac: brcmf_c_preinit_dcmds: Firmware version = wl0: Jan 23 2013 17:47:32 version 5.90.195.114 FWID 01-f9e7e464
> 
> so I wonder if it's just that the firmware in the Debian package
> (firmware-brcm80211) is outdated.  Any ideas why distros don't
> carry the 2013 firmware?

Okay, it's happened again - leading up to the event:

[52429.342374] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
[52431.902035] brcmfmac: brcmf_proto_bcdc_query_dcmd: brcmf_proto_bcdc_msg failed w/status -110
[52431.910749] brcmfmac: brcmf_cfg80211_get_station: GET STA INFO failed, -110
[64477.184237] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
[72565.439122] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)

and I guess this is where things went pear shaped:

[77842.523962] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[77843.515863] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[78439.934016] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[78440.921980] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[81442.351749] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[81443.343667] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[157822.092920] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)
[209836.023622] brcmfmac: brcmf_netdev_wait_pend8021x: Timed out waiting for no pending 802.1x packets
[209838.651573] brcmfmac: send_key_to_dongle: wsec_key error (-110)
[209843.515226] brcmfmac: brcmf_cfg80211_del_station: SCB_DEAUTHENTICATE_FOR_REASON failed -110
[219678.790941] br0: received packet on wlan0 with own address as source address (addr:6c:ad:f8:05:0d:81, vlan:0)

I'm now going to try with the later firmware:

brcmfmac: brcmf_c_preinit_dcmds: Firmware: BCM4330/4 wl0: Jan 23 2013 17:47:32 version 5.90.195.114 FWID 01-f9e7e464

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
