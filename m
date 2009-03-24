Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:50300 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182AbZCXTam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 15:30:42 -0400
MIME-Version: 1.0
Date: Tue, 24 Mar 2009 12:30:25 -0700
Message-ID: <43e72e890903241230y32a317cfga5f809748c5ab978@mail.gmail.com> (sfid-20090324_203049_203438_515976BA)
Subject: [RFC] Removing CONFIG_WIRELESS_OLD_REGULATORY plan
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, k roy <kroykroy@gmail.com>,
	Till Kamppeter <till.kamppeter@gmail.com>,
	Jussi Kukkonen <jku@linux.intel.com>,
	Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As a lot of you know we have a new regulatory implementation for Linux
wireless now [1]. We have kept the old regulatory implementation
through a Kconfig option, CONFIG_WIRELESS_OLD_REGULATORY.
Distributions are slowly converging to start setting this to "N" -- as
of 2.6.28. Distributions are also now shipping wireless-regdb [2] and
CRDA [3]. In the case of the absence of either of these we world roam.
For the 2.6.30 kernel we have added a new set of world roaming
improvements which include the ability to enable active scanning when
a beacon from an AP is found [4], and to also default to do passive
scan on the 5 GHz band [6].

We have had CONFIG_WIRELESS_OLD_REGULATORY in the feature removal
schedule marked for 2.6.29 but we have avoided doing so due to the the
distribution-catchup game and OLD_REG was still being set to default
to "Y".

Now with 2.6.29 released 2.6.30 merge window is closing, and I'd like
to review our current updated plans for the feature removal of the old
regulatory infrastructure. The plan is to ship 2.6.30 with OLD_REG
defaulting to "N", move along the ieee80211_regdom module parameter to
be available when OLD_REG is set to "N" and to not remove OLD_REG
until distributions being shipped start carrying decent userspace
replacements to provide regulatory hint information to the kernel.

For example, the cheap way to do this is to simply pick your country
someway and use iw to set the regulatory domain from part of an init
script. The next best thing is to get Network Manager to support
country selection and then pass that to wpa_supplicant to inform the
kernel. The impressive solution will be to integrate GeoClue [6] to
the standard Linux desktop and to make use of all location-aware
inputs on the desktop to determine your location. To this end the
GNOME and the Linux Foundation have Google Summer of Code projects [6]
to accomplish this. We will work with the GNOME folks to work together
on this so we can each help mentor each component involved
respectively. For details of the current ideas please see the links to
the project.

I should briefly note that this helps mostly Linux wireless drivers
which completely lack regulatory information or which rely on it
completely from userspace (examples are drivers which rely on the
Windows registry files for regdomain information). For drivers which
already have regulatory information that is always respected of
course, but we still let users help compliance even further. For
further details please to our regulatory implementation documentation
[1].

Our plan then is to not remove OLD_REG completely until we see some
decent userspace replacement on the Linux desktop being shipped and
help mentor the Linux wireless GeoClue GSoC 2009 project [8] (hint:
applications were opened yesterday, deadline is April 03).

For those still not clear exactly on what
CONFIG_WIRELESS_OLD_REGULATORY means please see our documentation [9]
on this.

So this is the plan... if there are any questions, hate mail or
comments please let me know.

  Luis

[1] http://wireless.kernel.org/en/developers/Regulatory
[2] http://wireless.kernel.org/en/developers/Regulatory#Theregulatorydatabase
[3] http://wireless.kernel.org/en/developers/Regulatory/CRDA
[4] http://marc.info/?l=linux-wireless&m=123519365605046&w=2
[5] http://marc.info/?l=linux-wireless&m=123519439405554&w=2
[6] http://www.freedesktop.org/wiki/Software/GeoClue
[7] https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009#802.11_Wireless
[8] https://www.linuxfoundation.org/en/Google_Summer_of_Code_2009#802.11_Wireless
[9] http://wireless.kernel.org/en/developers/Regulatory#Oldregulatoryimplementation
