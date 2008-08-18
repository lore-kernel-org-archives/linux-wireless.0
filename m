Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:38429 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbYHRIqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Aug 2008 04:46:39 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2984508wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 18 Aug 2008 01:46:38 -0700 (PDT)
Message-ID: <1197ff4c0808180146x1bb72246s3e18a14f170bb6c@mail.gmail.com> (sfid-20080818_104643_293816_1C02C2BB)
Date: Mon, 18 Aug 2008 16:46:38 +0800
From: YanBo <dreamfly281@gmail.com>
To: "Javier Cardona" <javier@cozybit.com>
Subject: Re: About MPP & MAP open80211 implementation status
Cc: devel@lists.open80211s.org,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <445f43ac0808132123t62cec7e0p8ab6b5d49c0baedc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1197ff4c0808112342h5fd41bf1pe565c15d0939686c@mail.gmail.com>
	 <445f43ac0808120938m73fd318eqb63ccc804743ccf7@mail.gmail.com>
	 <1197ff4c0808132008t12c7117dod11873686f3b8670@mail.gmail.com>
	 <445f43ac0808132123t62cec7e0p8ab6b5d49c0baedc@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>> On Mon, Aug 11, 2008 at 11:42 PM, YanBo <dreamfly281@gmail.com> wrote:
>>>> By reading the 8011s standard draft, it also define the MPP(Mesh
>>>> Portals) and MAP(Mesh Access  Point), I don't know does currently
>>>> open80211s project implement them?
>>>> I also read a file named olpc-mesh.pdf which is write by you, in this file you refer to MPP and
>>>> said  "L2 bridging not possible because of the 3-address problem"
>>>> want ask you guide what's your mean 3-address problem, do you mean all
>>>> currently b&g even n card doesn't support 6 mac address 80211s header?
>>>
>>> That presentation was for OLPC mesh, which had different requirements
>>> (e.g. work with legacy equipment, single radio) than o11s.  But the
>>> three address problem applies to o11s as well.  It happens when you
>>> try to connect the mesh to an outside network using an normal AP.
>>>
>>> A - AP -))    ((-B - C
>>>
>>> B, C: are mesh nodes.  B is associated with AP.
>>> Using 3-address 802.11 frames between AP and B, there is no way for A
>>> to reach C.
>>
>> By using 6 addresses mesh header, is it possible to make A can reach C?
>> And how B and C know the route info to reach A?
>
> No need for 6 address, just 4.  6 address are needed when mesh points
> are proxying non-mesh capable stations.
> But legacy APs don't know anything about 4 (nor 6) address frames.
> The "three adddress problem" is caused by the use of *legacy* (e.g.
> any unmodified off-the shelf) AP to connect a mesh portal to an
> external network.
> There is no problem if you use a wired ethernet connection and a
> standard 802.3 bridge between the wired and the mesh interface, e.g
>
> A -- ethernet -- B --- mesh --- C

In currently o11s implementation,  after bridge a wired and the mesh
interface, it seemed o11s can't correctly deal with the packet that
forward by 802.3 bridge. so A still can't reach C.

BR
yanbo
