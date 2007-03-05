Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:37903 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933245AbXCEVVB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2007 16:21:01 -0500
Message-ID: <45EC8001.9000102@warmcat.com>
Date: Mon, 05 Mar 2007 20:39:29 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Jouni Malinen <jkm@devicescape.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Question about PRISM2 header rate field
References: <45EA9E39.6080706@warmcat.com> <1173053744.6131.40.camel@johannes.berg> <45EB6C3B.2060408@warmcat.com> <200703042210.52534.flamingice@sourmilk.net> <1173094447.6131.56.camel@johannes.berg> <20070305165512.GB10947@devicescape.com>
In-Reply-To: <20070305165512.GB10947@devicescape.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> On Mon, Mar 05, 2007 at 12:34:07PM +0100, Johannes Berg wrote:
> 
>> But if you want to do injection over monitor interfaces we'll need to
>> have the stupid mgmt interface hack around forever for the userspace
>> MLME so it can receive only management traffic (even the non-promisc
>> monitor iface we should have gets *far* too much traffic for a userspace
>> MLME)
> 
> I'm probably fine with this with Linux socket filter. I haven't verified
> this, but I would assume it can match on the 802.11 header frace control
> field to select only management frames. I don't think I would like to
> see variable length pseudo-header before the 802.11 header, though, in
> this case.. It might be possible to parse that in the filter byte code,
> but it would certainly be easier if the filter code can just refer to
> the beginning of the 802.11 header.
> 
> It has been too long since I last used LSF and I think it was only for
> matching things in the IP header, so I don't remember what exactly can
> be matched in the headers before the IP headert and how easy this would
> be in case of monitoring headers. Before throughing away the management
> interface, someone would need to verify that this can indeed be done
> reasonably.

libpcap at least allows you to express presumably kernel-side filters like

"radio[0x4a:4]==0x13223344"

which means that the u32 at +0x4a bytes from the radio header (this is 
for Prism2) must match the constant.

What I saw earlier when wandering through some related code (ipw3945 or 
iwlwifi I think) was that other folks have adopted a hybrid system: they 
  used variable length radiotap headers alright but padded them to 0x40 
bytes length.  It's not the most beautiful architectural concept but 
since mac80211 will be filling in the monitor side with a canned set of 
radiotap elements it is in a position to guarantee no violation of it. 
For the injection side variable length incoming radiotap headers are 
probably no issue, since there is a length field at a fixed place near 
the start of the radiotap stuff and the BPF syntax isn't being applied.

>> Besides, to userspace, this is almost identical. In both cases it opens
>> a socket, binds to something (either raw socket bound to netdev or
>> netlink socket bound to nl80211) and then stuffs frames into that socket
>> with some fixed header format (for most apps anyway)
> 
> Well, almost identical still means a change to the kernel-user space
> interface.. Though, I think I would be willing to live with the
> consequencies in this case assuming we come up with a solution that is
> likely to stick for next several years without incompatible changes.

My guess is that whoever has to work with that management mode ioctl 
forest, with one half of it in userspace or the other half in kernel out 
of his control, will jump at the chance to replace it with a nice clean 
reliable packet injection mechanism where if the driver only honours the 
injection parameters, the usermode guy is in control of the whole 
association protocol "soup to nuts" and can monitor everything from 
tcpdump too.

-Andy
