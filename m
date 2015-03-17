Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbbCQXU0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2015 19:20:26 -0400
Message-ID: <1426634407.11120.50.camel@redhat.com> (sfid-20150318_002030_019750_95475777)
Subject: Re: Broadcom 43340
From: Dan Williams <dcbw@redhat.com>
To: =?ISO-8859-1?Q?J=FCrgen?= Bausa <juergen.Bausa@online.de>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Mar 2015 18:20:07 -0500
In-Reply-To: <loom.20150317T214603-379@post.gmane.org>
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>
		<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>
		<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>
	 <5504B29F.8000305@gmail.com> <55056EFB.9020100@broadcom.com>
	 <loom.20150315T213441-211@post.gmane.org> <5505F651.3060607@broadcom.com>
	 <loom.20150317T214603-379@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-03-17 at 21:01 +0000, Jürgen Bausa wrote:
> Arend van Spriel <arend@...> writes:
> 
> > 
> > On 03/15/15 21:38, Jürgen Bausa wrote:
> > >
> > > would be nice, if you could make it clear.
> > >
> > 
> > Maybe you need to mount it. This is what I found [1]:
> > 
> > $ sudo mount -t efivarfs none /sys/firmware/efi/efivars
> > 
> 
> Thanks, that worked. Now I have firmware and nvram-file and the driver seems
> to load ok. At least I have an interface wlan0.
> 
> However, I am not able to connect.Network-manager just says "interface is
> being set up ..." forever. I have no idea howto debug this. In the other
> post you said that the nl80211 driver should be used instead of wext. I
> found that nl80211 is the default for network-manager. So, whats going wrong
> here?

Could you provide more NetworkManager logs?  They should look like this;
where do your logs stop?

NetworkManager[1949]: <info>  (wlan0): Activation: starting connection 'my wifi'
NetworkManager[1949]: <info>  (wlan0): Activation: Stage 1 of 5 (Device Prepare) scheduled...
NetworkManager[1949]: <info>  (wlan0): Activation: Stage 1 of 5 (Device Prepare) started...
NetworkManager[1949]: <info>  (wlan0): device state change: disconnected -> prepare (reason 'none') [30 40 0]
NetworkManager[1949]: <info>  (wlan0): Activation: Stage 2 of 5 (Device Configure) scheduled...
NetworkManager[1949]: <info>  (wlan0): Activation: Stage 1 of 5 (Device Prepare) complete.
NetworkManager[1949]: <info>  (wlan0): Activation: Stage 2 of 5 (Device Configure) starting...
NetworkManager[1949]: <info>  (wlan0): device state change: prepare -> config (reason 'none') [40 50 0]
NetworkManager[1949]: <info>  (wlan0): Activation: (wifi) connection 'my wifi' has security, and secrets exist.  No new secrets needed.
NetworkManager[1949]: <info>  Config: added 'ssid' value 'my wifi'
NetworkManager[1949]: <info>  Config: added 'scan_ssid' value '1'
NetworkManager[1949]: <info>  Config: added 'key_mgmt' value 'WPA-PSK'
NetworkManager[1949]: <info>  Config: added 'psk' value '<omitted>'
NetworkManager[1949]: <info>  Config: added 'proto' value 'WPA RSN'
NetworkManager[1949]: <info>  (wlan0): Activation: Stage 2 of 5 (Device Configure) complete.
NetworkManager[1949]: <info>  Config: set interface ap_scan to 1
NetworkManager[1949]: <info>  (wlan0): supplicant interface state: inactive -> scanning
NetworkManager[1949]: <info>  (wlan0): supplicant interface state: scanning -> authenticating
NetworkManager[1949]: <info>  (wlan0): supplicant interface state: authenticating -> associating
NetworkManager[1949]: <info>  (wlan0): supplicant interface state: associating -> associated
NetworkManager[1949]: <info>  (wlan0): supplicant interface state: associated -> 4-way handshake
NetworkManager[1949]: <info>  (wlan0): supplicant interface state: 4-way handshake -> completed

Dan

