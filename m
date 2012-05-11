Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63718 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761157Ab2EKXuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 19:50:51 -0400
Received: by yhmm54 with SMTP id m54so3164639yhm.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2012 16:50:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FAD2B8D.8090104@microhardcorp.com>
References: <4FAC2B98.6040100@microhardcorp.com> <CAG6hwVPanDNoWCK-dA2V3gpz8cJhQ-5oJZLXng0rrUXQngPPww@mail.gmail.com>
 <4FAD2B8D.8090104@microhardcorp.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 11 May 2012 16:50:30 -0700
Message-ID: <CAG6hwVOJTCc8uUTo_WXRSSm63On3LT+cVPqMTCfQxrLnkk_4MA@mail.gmail.com> (sfid-20120512_015055_361806_B2877582)
Subject: Re: MESH only works at 54Mbps link rate or below?
To: Bin Zeng <bzeng@microhardcorp.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bin,

On Fri, May 11, 2012 at 8:09 AM, Bin Zeng <bzeng@microhardcorp.com> wrote:
> Thomas,
>
> Yes, I did like that.
> iw phy phy0 interface add mesh0 type mp mesh_id mymesh
> iw dev mesh0 set channel 48 HT20
> ifconfig mesh0 up
>
> However, if I use iw to set bitrate, something like that "iw mesh0 set
> bitrates legacy-5 54 mcs-5 15". Then use "iw dev mesh0 station dump" to
> check bitrate. It seems like only show 54Mbps or below bitrates. HT mcs rate
> can not be controlled?
>
>
> Any help appreciate.

I haven't tried this myself, but I believe the bitrates only affect
the rate control algorithm.  Do you see higher rates if you omit the
'iw set bitrates' command?

'iw set bitrates' should probably also be issued before bringing up the mesh.

Thomas
