Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:42214 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab0DVUvB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 16:51:01 -0400
Subject: Re: [PATCH] compat: fix uevent_suppress on 2.6.29 or older kernels
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <x2l43e72e891004221333he942ee92u3ef4c6994d769694@mail.gmail.com>
References: <1271944442-9214-1-git-send-email-notasas@gmail.com>
	 <g2o43e72e891004220933i5faec995qae1b358ce66ed2d@mail.gmail.com>
	 <1271954537.8469.15.camel@mj>
	 <x2l43e72e891004221333he942ee92u3ef4c6994d769694@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 22 Apr 2010 16:50:59 -0400
Message-Id: <1271969459.11483.3.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-04-22 at 13:33 -0700, Luis R. Rodriguez wrote:
> On Thu, Apr 22, 2010 at 9:42 AM, Pavel Roskin <proski@gnu.org> wrote:
> > On Thu, 2010-04-22 at 09:33 -0700, Luis R. Rodriguez wrote:
> >
> >> How was this compiling for older kernels before then?
> >
> > Compiling was fine, but loading the firmware was failing sometimes.  I'm
> > glad somebody figured it out.  Thank you, Grazvydas!
> 
> OK Applied. I'm still puzzled, if it compiled, then that means
> dev_set_uevent_suppress() was being defined somehow for older kernels.

It's wasn't defined.  The function just wasn't called for older kernels.
"#if" was there; the patch added "#else".

It's a great example how simply-minded commenting out missing functions
can lead to a hard problem, a race condition.

-- 
Regards,
Pavel Roskin
