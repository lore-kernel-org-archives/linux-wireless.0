Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:34738 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbZAIQG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 11:06:29 -0500
Received: by fg-out-1718.google.com with SMTP id 19so3464855fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 09 Jan 2009 08:06:27 -0800 (PST)
Message-ID: <69e28c910901090806n5bc4ef37xf5975bb5c9389d3d@mail.gmail.com> (sfid-20090109_170634_228205_09FFF771)
Date: Fri, 9 Jan 2009 17:06:26 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Subject: BUG: SYSASSERT while running aireplay-ng's fakeauth feature on an IWL4965AGN monitor interface (cross-posted from Bugzilla)
Cc: "Zhu Yi" <yi.zhu@intel.com>, "Tomas Winkler" <tomasw@gmail.com>,
	"criple gangsta" <criple_gangsta@hotmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Cross-posted from
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1879)

Aireplay-ng's "fakeauth" feature simulates an authentication/association
sequence by injecting and sniffing frames on a monitor interface. This works
perfectly for 3945ABG and IWL5xxx cards (as well as non-Intel cards with
mac80211-based drivers), but fails with a SYSASSERT Microcode SW error on 4965.
The error specifically happens after the association request frame is
transmitted, the authentication sequence is completed successfully. I am not
sure whether the error occurs upon TX of the association request or upon
subsequent RX of the association response. However, judging from the
information I have so far, the most probable sequence of events is the
following:

Inject authentication request: success
Receive ACK from AP: success
Receive authentication response: success
Send ACK to AP: success
Inject association request: success
Receive ACK from AP: success
Receive association response: SYSASSERT
Send ACK to AP: ucode not ready

Steps to reproduce:
1. Load iwlagn with at least debug=0x43fff (to see the complete error dumps).
2. Create at least one monitor interface on the affected PHY (the presence of
additional interfaces does not seem to affect the outcome). I'll refer to this
interface as mon0.
3. Have a WEP-encrypted AP with no MAC filtering and no shared-key auth ready
and in range. Set the card to the same channel as this AP.
4. Run the command "aireplay-ng -1 0 -e <ESSID of AP> -a <BSSID of AP> mon0"
(replace mon0 with your monitor interface). Aireplay-ng will retry the
auth/assoc sequence a few times, and print a failure. Dmesg shows that a
SYSASSERT has occurred.

http://pastebin.com/m4c0e5260 is a dmesg dump of the SYSASSERT. The
bug occurs the same in both
2.6.28 and the latest wireless-testing, and is distro-agnostic.


-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
