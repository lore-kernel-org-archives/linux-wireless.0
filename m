Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:36786 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbbDNFez convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Apr 2015 01:34:55 -0400
Received: by wgsk9 with SMTP id k9so102699163wgs.3
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2015 22:34:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <552C5AE9.4050304@candelatech.com>
References: <55285D8D.6070703@candelatech.com>
	<552BFFB8.6030301@candelatech.com>
	<552C5AE9.4050304@candelatech.com>
Date: Tue, 14 Apr 2015 07:34:53 +0200
Message-ID: <CA+BoTQ=C0xxDifiiQVbyBe=OHYUjzHcu49mULJpU+=2SNCZ-dQ@mail.gmail.com> (sfid-20150414_073458_507133_1A8C610C)
Subject: Re: CT ath10k firmware now supports IBSS + RSN
From: Michal Kazior <michal.kazior@tieto.com>
To: Ben Greear <greearb@candelatech.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14 April 2015 at 02:10, Ben Greear <greearb@candelatech.com> wrote:
> On 04/13/2015 10:41 AM, Ben Greear wrote:
>> Looks like I have some more work to do.  For any moderately large frames,
>> I am now dropping the last 16 bytes.  Looks like the skb_put_padto logic
>> was working around a more serious issue...
>
> A better-tested version of kernel and firmware is uploaded now.
>
> Looks like I needed to add a hack to firmware to bump pkt-size by
> 16 for IBSS + RSN encrypted frames.  Not sure exactly why, but seems
> to work in light testing.
>
> I removed the skb-padto hack from the kernel, and kernel is rebased on
> top of official 4.0 now.

Hmm.. Maybe this is related to MMIC. Maybe frame fragment length must
be different from frame length (ath10k_htt_tx(),
htt_data_tx_desc_frag)? Perhaps a similar hack as with RAW txmode[1]
needs to be applied..?


[1]: https://www.mail-archive.com/ath10k@lists.infradead.org/msg00241.html


Michał
