Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.comnets.rwth-aachen.de ([137.226.4.160]:54518 "EHLO
	gin.comnets.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756424AbXKNASB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2007 19:18:01 -0500
Message-ID: <473A3D1F.7090703@ieee.org> (sfid-20071114_001806_573485_76D93675)
Date: Wed, 14 Nov 2007 01:11:11 +0100
From: "Guido R. Hiertz" <hiertz@ieee.org>
MIME-Version: 1.0
To: Javier Cardona <javier@cozybit.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3/4] o80211s: (mac80211s) basic mesh interface support
References: <473516ee.26d7720a.3f57.ffff8233@mx.google.com>	 <1194689500.7258.61.camel@johannes.berg>	 <445f43ac0711101603s18cd70a7lb70dedea8cc5c3c0@mail.gmail.com>	 <1194866072.5229.8.camel@johannes.berg> <445f43ac0711131231s5bfd173v1c9105e9f23d83b2@mail.gmail.com>
In-Reply-To: <445f43ac0711131231s5bfd173v1c9105e9f23d83b2@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

2007-11-13 21:31 wrote Javier Cardona:
> On 11/12/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>> As far as I understand the specification, this
>> [different MAC address for the mesh interface] is not required.

That's true. The current text doesn't require this. However, it'll change.

>> Since we currently have no drivers supporting multi-MAC operation,
>> this is quite a severe limitation and the draft seems to allow MAP
>> operation with a single address, cf. the description of the SSID
>> element in 7.2.3.1 (Beacon frame format). ("Note: the SSID is a
>> required IE in beacon frames. To avoid having non-mesh STAs [...]")

Yeah. It's still a mess. The best thing is to consider an MAP as two 
separate entities. One is an MP the other is an AP.

802.11-2007 describes the AP. There is nothing that 802.11s would add to 
that. 802.11s solely defines the MP. As a maximum, 802.11s might give 
some hints what to observe when an MP collocates with other entities 
(AP, HC ...).

We had an extensive discussion about the beacon stuff in 802.11s. As the 
group believes that the MP is a separate logic entity, it sends its own 
beacon. A combined beacon is not foreseen. However, until now the latest 
draft still has too much "legacy" (=non-mesh) and refers to BSS 
operation etc. Therefore, there are these nasty tricks (SSID = wildcard 
etc.). As soon as the group will require a separate MAC addresses when 
an MP collocates with an AP, they'll also realize that a lot of existing 
beacon IEs are unnecessary for the mesh. Then, there will also be no 
need for tricks to prevent stations from trying to associate with an MP.

>> Therefore, I think that having a separate MAP type device would be
>> beneficial because that allows hostapd to generate a beacon including an
>> SSID, respond to probe requests and still be a mesh point on the same
>> interface.

During the discussion on the 802.11 e-mail reflector some people 
described such a combined beacon. However, this construct is not 
foreseen. It's really out of scope of 802.11s.

I know that there are existing products in the market that do similar 
things. However, 802.11s really decouples its concept of the mesh and 
the mesh devices from non-mesh devices. Thus, the mesh uses separate 
beacons.

>> The only way hostapd would have to be aware of this is that it
>> needs to create a different type of interface and include the mesh 
>> information in the beacon.

With separate beacon frames for the mesh and the BSS, the mesh may also 
use a totally different beacon interval. Thus, 802.11s networks can 
benefit from reduced overhead.

As there are already concerns about beacon bloat, I fear there will be 
no chance for a combined beacon that carries information for both the 
mesh and the BSS.

>> Do you see anything precluding such operation? Some more logic would
>> have to be provided to achieve the appropriate mesh broad/multicast vs.
>> AP broad/multicast behaviour, of course, as described elsewhere wrt.
>> mesh broad/multicast frames being broad/multicast to associated STAs.
> 
> The issue of mesh beacons is an open discussion at TGs right now (and
> by now I mean this week, in the IEEE 802.11 plenary in Atlanta).  It
> looks like a different mac address will be needed for the mesh
> interface if collocated with an AP. That will be necessary for
> security and to avoid conflicts with legacy equipment. In that case,
> the stack should generate the mesh beacons and hostapd generate the
> infrastructure beacons.

That's right. I support Javier's point of view. Both networks are very 
different. The BSS has a hierarchy of an AP and its associated stations. 
A mesh will always be distributed. Thus, beacon frames serve different 
purposes in both networks. I would propose to strictly decouple both 
functionality and to keep them separated.

> Anyway, I see no problem in renaming this IEEE80211_IF_TYPE_MESH_POINT
> (even though I just heard of a proposal to rename Mesh Points as Mesh
> Stations... )

Well ... That's another story :-)

Best regards,

Guido

-- 
Dipl.-Ing. Guido R. Hiertz      | mailto:grh@comnets.rwth-aachen.de
Chair of Communication Networks | http://www.comnets.rwth-aachen.de/~grh
RWTH Aachen University          | Phone: +49 241 802 5829
