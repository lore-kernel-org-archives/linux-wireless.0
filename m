Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:38321 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbaEZJht (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 05:37:49 -0400
Received: by mail-qc0-f172.google.com with SMTP id l6so11849408qcy.3
        for <linux-wireless@vger.kernel.org>; Mon, 26 May 2014 02:37:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEFj987H_aVYyAH0jtOSe4Jbwx-Af=-8Fw+U5dC5=mmVZKy4AA@mail.gmail.com>
References: <3893194.GDQagdLGN9@desktop.local> <20140522192720.GA13440@localhost>
 <CAGnRvuqUkebLhvqY1Y28NtRyp3uUdbrpOSb4dOX2+ZSg6qineg@mail.gmail.com>
 <CAEFj9850c9aD5gKz2B-e=hPnS2vNdY+a4uc9D_+psryE0ywDVA@mail.gmail.com>
 <CAGnRvuo_ydU-HwtyTeKP50GPjEiNQy1EoVMR5_Dg-qTrFjYkPg@mail.gmail.com>
 <20140523205717.GB6585@localhost> <CAEFj987H_aVYyAH0jtOSe4Jbwx-Af=-8Fw+U5dC5=mmVZKy4AA@mail.gmail.com>
From: Henning Rogge <hrogge@gmail.com>
Date: Mon, 26 May 2014 11:37:28 +0200
Message-ID: <CAGnRvuqyrP=e6g1sJY9xiWUbT68N4syUkUDw9Xz+-paSPrudfA@mail.gmail.com> (sfid-20140526_113752_962985_B0584406)
Subject: Re: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
To: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@noack.us>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I think this would require to know the mac addresses of the remote
nodes... but maybe I will look into changing the timeout value.

Henning Rogge

On Mon, May 26, 2014 at 8:47 AM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> For disable HWMP, in additional to disable frame forwarding and set
> mesh TTL to 1, you can force specific mpath using "iw mesh0 mpath set
> <MACx> next_hop <MACx>". In this case, you will disable the path
> refresh.
>
> ----
> Chun-Yeow
>
> On Sat, May 24, 2014 at 4:57 AM, Bob Copeland <me@bobcopeland.com> wrote:
>> On Fri, May 23, 2014 at 12:52:57PM +0200, Henning Rogge wrote:
>>> Hi,
>>>
>>> I will have another look at the codebase next week, there was a lot of
>>> similar code for both tables that could be simplified without throwing
>>> them together.
>>>
>>> The feeling I get here is that four new nl80211 commands
>>> (set/get/del/dump mpp_paths) are the right way to export these values?
>>
>> That approach would be fine by me.  Thanks for working on this!
>>
>> --
>> Bob Copeland %% www.bobcopeland.com
