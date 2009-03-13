Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:9304 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbZCMPCN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 11:02:13 -0400
Received: by fg-out-1718.google.com with SMTP id 16so851198fgg.17
        for <linux-wireless@vger.kernel.org>; Fri, 13 Mar 2009 08:02:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910902091056h119b3fa4g460e5e18288c1c3c@mail.gmail.com>
References: <69e28c910902091056h119b3fa4g460e5e18288c1c3c@mail.gmail.com>
Date: Fri, 13 Mar 2009 16:02:09 +0100
Message-ID: <69e28c910903130802t1bd879av50e3d51c075f6e2c@mail.gmail.com> (sfid-20090313_160215_269434_88A181AB)
Subject: [Resend] Proposal: Add a new flag to the proposed TX flags field to
	control the sequence number of injected packets
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
To: radiotap@radiotap.org, Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently the TX Flags field is defined as a bitmap containing:
0x0001 Transmission failed due to excessive retries
0x0002 Transmission used CTS-to-self protection
0x0004 Transmission used RTS/CTS handshake
0x0008 Transmission shall not expect an ACK frame and not retry when
no ACK is received

I'd like to propose the following additional bit:
0x0010 Transmission has the sequence and fragment numbers pre-set from
userspace and should not be renumbered

This bit is useful for packet injection, where userspace injectors
might want to control the sequence and fragment numbers of the packets
it injects. A particular example is aireplay-ng's -5 mode
(fragmentation attack), where userspace injects pre-made fragments
one-by-one. The wireless stack usually can't recognize that the
injected packets are fragments, and instead treats them as complete
packets, assigning a new sequence number to each fragment, preventing
the receiving party from correctly reassembling the fragmented packet.
The userspace does however know that the packets being injected are
fragments, and such can produce much more correct sequence numbers for
them. So, userspace can in these cases set TX_FLAGS |=3D3D 0x0010 and p=
ut
pre-generated sequence numbers on the packets it injects.

Similar to how 0x0008 works, this bit also should be used when packets
are being sent, as opposed to when they are being reported as having
been sent (like the first 3 bits).

I have posted a reference implementation on the linux-wireless mailing
list about a month ago, and it is also available here:
http://trac.aircrack-ng.org/svn/trunk/patches/mac80211_2.6.28-rc8-wl_fr=
ag+a=3D
ck_radiotap.patch
(Note that this patch may not clearly apply to 2.6.29-rc2 or the
current wireless-testing kernel, as it was made against the
master-2008-12-17 tag of wireless-testing.)

G=E1bor
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
