Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:25628 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126AbXITPPy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 11:15:54 -0400
Received: by an-out-0708.google.com with SMTP id d31so84660and
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2007 08:15:54 -0700 (PDT)
Message-ID: <43e72e890709200815v4b165454vff8691ca9200319a@mail.gmail.com>
Date: Thu, 20 Sep 2007 11:15:53 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Fwd: [Madwifi-devel] [ANNOUNCE] MadWifi project moves away from binary-only HAL in favor of ath5k
In-Reply-To: <2312.194.45.26.221.1190300304.squirrel@webmail.madwifi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <2312.194.45.26.221.1190300304.squirrel@webmail.madwifi.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI - MadWifi has now shifted development focus to ath5k.

  Luis

---------- Forwarded message ----------
From: Michael Renzmann <mrenzmann@madwifi.org>
Date: Sep 20, 2007 10:58 AM
Subject: [Madwifi-devel] [ANNOUNCE] MadWifi project moves away from
binary-only HAL in favor of ath5k
To: madwifi-users@lists.sourceforge.net, madwifi-devel@lists.sourceforge.net


Hi all.

We, the MadWifi team, announce our decision to move away from the
binary-only HAL and change the focus of our future development towards
ath5k [1], a completely free (as in freedom) driver which will eventually
become an integral part of the Linux kernel. We encourage all interested
developers to join us and contribute to our efforts.

For those who are not familiar with the concept, the proprietary "Hardware
Abstraction Layer" (HAL) [2] was designed as compromise to allow at least
one Free and Open Source Software (FOSS) wireless driver component. Unlike
many other wireless devices Atheros chipsets can use a wide range of
frequencies and the host software can control many aspects of the radio.
Regulatory agencies all over the world have laws which restrict the use of
the wireless spectrum to certain frequency bands under specific
transmission power levels. These laws drive wireless manufacturers to come
up with solutions to enforce compliance with the wide array of regulatory
agencies. The binary HAL is a wrapper around all chipset registers, and
all direct hardware access is routed through it. This approach ensures
that non-compliant settings are not applied to the radio, while allowing
the open source part of the driver to interact with the chipset in a
permissive manner.

We understand Atheros' reasons for introducing the HAL and distributing it
in binary form only, and we supported it. But this decision forced us to
deal with a black box that we could neither fix nor fully understand - a
major issue for a free software project. This prevented MadWifi from
appearing in many Linux distributions. Because of the proprietary HAL and
since the MadWifi driver also did not make use of the new mac80211 layer
in Linux it has been impossible for it to become part of the Linux kernel.
It's also been clear to us that the "security through obscurity" approach
won't work to protect the hardware against unlawful use. Regardless, we
kept working on MadWifi as no acceptable alternative existed.

This situation has changed.

A driver for Atheros wireless cards is available in OpenBSD that talks
directly to the hardware, based on reverse engineering efforts done by
Reyk Floeter. Relevant parts of the driver have been ported to Linux by
Nick Kossifidis to start OpenHAL [3], a free (as in freedom) replacement
of the proprietary HAL. Claims that the OpenBSD driver (and thus also
OpenHAL) contains stolen code slowed down the OpenHAL efforts but finally
could be voided. The Software Freedom Law Center (SFLC) [4], with the help
of Atheros, performed a thorough code review and concluded "that OpenHAL
does not infringe copyrights held by Atheros" [5]. In other words, the way
is clear now for the inclusion of an OpenHAL-based driver into the Linux
kernel.

Another important development is the work on a "central regulatory domain
agent". It aims to ensure compliance with the regulatory constraints and
rules based on the current location of the user. The agent and its
integration with the kernel will allow wireless LAN drivers to enforce
local regulations without requiring non-free software for that task. This
work will soon be published for merging with the upstream kernel.

We now see a road to move away from the binary-only HAL; it's no
comfortable road, however, and thus requires full concentration of our
resources to finally reach the ultimate goal of getting a free driver for
Atheros devices into the Linux kernel. This free driver is called ath5k,
and the work on it has already been started. We are also in contact with
Atheros to encourage them to support these efforts.

To underline our decision and commitment to ath5k we now declare MadWifi
"legacy.". In the long run ath5k will replace the MadWifi driver. For the
time being MadWifi will still be supported, bugs will get fixed and HAL
updates will be applied where possible. But it becomes unlikely that we'll
see new features or go through major changes on that codebase. The only
exception to this is the work spent on improved support for Dynamic
Frequency Selection (DFS) [6], which is used for avoiding interference
with radars.

Users who need stable and solid WLAN support for their Linux computers
should stick with MadWifi for now. Interested parties are welcome to try
ath5k and any constructive feedback is highly appreciated.

We encourage developers to contribute [7] to the free driver efforts -
it's still a long way before we reach the goal of a truly free Atheros
driver for Linux, and every helping hand is welcome.

If you have any questions, feel free to ask. Thanks for listening.

  -- The MadWifi Team

Links:
[1] http://madwifi.org/wiki/About/ath5k
[2] http://madwifi.org/wiki/About/HAL
[3] http://madwifi.org/wiki/About/OpenHAL
[4] http://softwarefreedom.org/
[5] http://www.softwarefreedom.org/news/2007/jul/31/openhal/
[6] http://en.wikipedia.org/wiki/IEEE_802.11h#DFS_Dynamic_Frequency_Selection
[7] http://linuxwireless.org/en/users/Drivers/ath5k#Hackingath5k


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
Madwifi-devel mailing list
Madwifi-devel@lists.sourceforge.net
https://lists.sourceforge.net/lists/listinfo/madwifi-devel
