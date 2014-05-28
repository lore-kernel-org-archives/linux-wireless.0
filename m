Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:37361 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaE1Kzj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 06:55:39 -0400
Received: by mail-qg0-f45.google.com with SMTP id z60so16962658qgd.18
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 03:55:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj98755Zfjs_MOXFEF+PPRKH5Q+UVsURmAcf-CKKkVfnrTLA@mail.gmail.com>
References: <2083629.VLZzpqGjAs@desktop.local> <CAEFj98755Zfjs_MOXFEF+PPRKH5Q+UVsURmAcf-CKKkVfnrTLA@mail.gmail.com>
From: Henning Rogge <hrogge@gmail.com>
Date: Wed, 28 May 2014 12:55:18 +0200
Message-ID: <CAGnRvuq=aLFhFuE=ntJ1GkFFf_UNQjDxx2KcGMdskRycunZbaA@mail.gmail.com> (sfid-20140528_125542_229559_EE841540)
Subject: Re: [RFC Patch v2] Unify mpp/mesh_path handling for Mac 802.11s
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Thomas Pedersen <thomas@noack.us>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 28, 2014 at 12:43 PM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
>> While looking through the code I noticed that there seems to be no code-path
>> that removes stall mpp_path entries (except for the removal of the mesh
>> interface) ! Unless I overlooked something this would be a way to use up all
>> existing memory of the kernel by sending it 802.11s packets with changing
>> proxied addresses.
>
> AFAIK, we don't really "manage" the mpp path and relying on incoming
> packet to update the mpp path table.

Imagine a malicious or maybe misbehaving node that is sending you
proxied traffic and is just counting up the source mac address. Every
received packet would generate another entry in the mpp_path table.

Even without this, one usecase for 802.11s is to connect multiple
access points and allow clients to roam between them and not loosing
internet connectivity through a gateway. A scenario like this would
have one mpp_path table entry for every client that has connected to
the network... even if it has been years ago.

Henning Rogge
