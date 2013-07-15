Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:49103 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3GOJfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 05:35:45 -0400
Date: Mon, 15 Jul 2013 11:35:44 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Sedat Dilek <sedat.dilek@gmail.com>, peizhao.research@gmail.com,
	linux-wireless@vger.kernel.org
Subject: Re: kernel panic on 3.10.0-rc7
Message-ID: <20130715093544.GA15055@shrek.podlesie.net> (sfid-20130715_113548_820065_FA045EF4)
References: <51D127E4.2080803@gmail.com>
 <CA+icZUUQHySKu=qEW3xfheg3DSMuvgB7Dp5PzVGOaiziAPTa5g@mail.gmail.com>
 <20130715085239.GA31630@shrek.podlesie.net>
 <51E3BB93.2090000@openwrt.org>
 <20130715092730.GA12765@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130715092730.GA12765@shrek.podlesie.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 15, 2013 at 11:27:30AM +0200, Krzysztof Mazur wrote:
> On Mon, Jul 15, 2013 at 11:06:27AM +0200, Felix Fietkau wrote:
> > Please post the actual message output. Saying "it looks like something
> > wrong with the rate control mechanism" doesn't give me anything useful
> > to work with.
> > 
> 
> Sorry, I added you to Cc after I removed the original Oops.
> 

On my system the NULL pointer dereference occurs at 0x806389b0,
and the minstrel_get_rate() looks like:

80638990 <minstrel_get_rate>:
80638990:	83 ec 1c             	sub    $0x1c,%esp
80638993:	89 7c 24 14          	mov    %edi,0x14(%esp)
80638997:	8b 7c 24 20          	mov    0x20(%esp),%edi
8063899b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8063899f:	89 cb                	mov    %ecx,%ebx
806389a1:	89 6c 24 18          	mov    %ebp,0x18(%esp)
806389a5:	89 c5                	mov    %eax,%ebp
806389a7:	89 d0                	mov    %edx,%eax
806389a9:	89 74 24 10          	mov    %esi,0x10(%esp)
806389ad:	8b 77 0c             	mov    0xc(%edi),%esi
* 806389b0:	0f b6 49 38          	movzbl 0x38(%ecx),%ecx *
806389b4:	8d 56 20             	lea    0x20(%esi),%edx
806389b7:	89 54 24 04          	mov    %edx,0x4(%esp)
806389bb:	89 da                	mov    %ebx,%edx
806389bd:	88 4c 24 0b          	mov    %cl,0xb(%esp)
806389c1:	89 f9                	mov    %edi,%ecx
806389c3:	e8 38 2f fe ff       	call   8061b900 <rate_control_send_low>

Krzysiek
