Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f173.google.com ([209.85.220.173]:56153 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbaEZGrV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 02:47:21 -0400
Received: by mail-vc0-f173.google.com with SMTP id il7so8817644vcb.32
        for <linux-wireless@vger.kernel.org>; Sun, 25 May 2014 23:47:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140523205717.GB6585@localhost>
References: <3893194.GDQagdLGN9@desktop.local>
	<20140522192720.GA13440@localhost>
	<CAGnRvuqUkebLhvqY1Y28NtRyp3uUdbrpOSb4dOX2+ZSg6qineg@mail.gmail.com>
	<CAEFj9850c9aD5gKz2B-e=hPnS2vNdY+a4uc9D_+psryE0ywDVA@mail.gmail.com>
	<CAGnRvuo_ydU-HwtyTeKP50GPjEiNQy1EoVMR5_Dg-qTrFjYkPg@mail.gmail.com>
	<20140523205717.GB6585@localhost>
Date: Mon, 26 May 2014 14:47:19 +0800
Message-ID: <CAEFj987H_aVYyAH0jtOSe4Jbwx-Af=-8Fw+U5dC5=mmVZKy4AA@mail.gmail.com> (sfid-20140526_084724_350299_E88DA7AE)
Subject: Re: [RFC Patch] Unify mpp/mesh_path handling for Mac 802.11s
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Henning Rogge <hrogge@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <thomas@noack.us>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For disable HWMP, in additional to disable frame forwarding and set
mesh TTL to 1, you can force specific mpath using "iw mesh0 mpath set
<MACx> next_hop <MACx>". In this case, you will disable the path
refresh.

----
Chun-Yeow

On Sat, May 24, 2014 at 4:57 AM, Bob Copeland <me@bobcopeland.com> wrote:
> On Fri, May 23, 2014 at 12:52:57PM +0200, Henning Rogge wrote:
>> Hi,
>>
>> I will have another look at the codebase next week, there was a lot of
>> similar code for both tables that could be simplified without throwing
>> them together.
>>
>> The feeling I get here is that four new nl80211 commands
>> (set/get/del/dump mpp_paths) are the right way to export these values?
>
> That approach would be fine by me.  Thanks for working on this!
>
> --
> Bob Copeland %% www.bobcopeland.com
