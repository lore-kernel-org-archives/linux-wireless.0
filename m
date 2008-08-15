Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:54541 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbYHOFZW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Aug 2008 01:25:22 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1177497wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 22:25:22 -0700 (PDT)
Message-ID: <1197ff4c0808142225p1469d32na94907bbed816afe@mail.gmail.com> (sfid-20080815_072527_054267_82713CC1)
Date: Fri, 15 Aug 2008 13:25:22 +0800
From: YanBo <dreamfly281@gmail.com>
To: devel@lists.open80211s.org
Subject: Bridge the mesh interface and wired ethernet interface to construct a MPP(Mesh Portals)
Cc: wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

When I tried to bridge a mesh interface with another wired ethernet
interface to construct a MPP, it seemed they can't communicate each
other.

The test what I do is like below:
1. Mesh node B has connected with another mesh node D
2. Bridge a wired interface A with  mesh interface B get a bridge
interface C (assume A's mac address value is larger than B's mac
address value )
3. Set interface D and C  in the same IP segment.
When ping C with D
B will broadcast a ARP packet which the addr4 is C's mac address
when D received this broadcast ARP packet, D want do a ARP reply to C
but D found C's address is not in the mesh neighbor table, and then D
will send a path request  try to find how to reach C
when B received this path_request, B also don't know who is C, and
then just forward this mesh path request and don't do anything.
then D can't reach C

As we know the bridge's mac address is the same as the the least mac
address of all it's interfaces, so if C's mac address is the same as
B's, then D will reach C. but this is just a coincidence.


so in my opinion, the solution is when the bridge pass the packet from
C to B, B need record C's mac address,. and when D receives the ARP
request  that from B. D also need record the path that D->B->C, then
when D try to send ARP reply to C,  D just need send the packet to B,
and B also know it can reach C directly and don't need forward this
packet. so C and reach D and D also can reach C.  after rough browser
the mesh code, it seemed it hasn't not deal with this situation,  so
I'd want ask is there anybody meet the same problem or have better
solution, or is it worth to do?  if so I'd like to implement this
function, and the mesh will can be integration with Bridge without
problem.  any comments or suggestion is welcome!


Yanbo
