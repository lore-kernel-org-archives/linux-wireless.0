Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f189.google.com ([209.85.221.189]:53041 "EHLO
	mail-qy0-f189.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab0DPBqx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 21:46:53 -0400
Received: by qyk27 with SMTP id 27so2460692qyk.23
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 18:46:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1271108966.15194.4.camel@mj>
References: <n2icdc21431004112229n9303fcc1s788eadda177d079a@mail.gmail.com>
	 <1271108966.15194.4.camel@mj>
Date: Thu, 15 Apr 2010 20:46:51 -0500
Message-ID: <o2pcdc21431004151846v1a542521rb73d157f4c26163b@mail.gmail.com>
Subject: Re: [ath9k-devel] On ath9k debugfs, having trouble recompiling and
	inserting only ath9k
From: Rakesh Kumar <gopchandani@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Maybe /sys/kernel/debug/ath9k is already present.  You may want to
> reboot to "fix" it.

Yeah, it was due to the order of delete entry calls. I had included
one more debugfs u8 entry which was being deleted after the
directory's entry and thus not being deleted at all and on the next
run it would cause trouble on creation.  Thanks.

--
Rakesh
