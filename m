Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:50912 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757382Ab0JLRPd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 13:15:33 -0400
Received: by qwa26 with SMTP id 26so527311qwa.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 10:15:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010121933.59209.br1@einfach.org>
References: <201010121933.59209.br1@einfach.org>
Date: Tue, 12 Oct 2010 13:15:29 -0400
Message-ID: <AANLkTikSE0GBDo_++YfYD4kwS3oEHMBtWm0B96-BWEBe@mail.gmail.com>
Subject: Re: [ath5k-devel] How to profile this strange effect under high load?
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 12, 2010 at 6:33 AM, Bruno Randolf <br1@einfach.org> wrote:
> So my question is: How can I find out, what [phy1] is so busy doing? Any ideas
> how to profile this?

/proc/interrupts shows lots of interrupts on phy1 line?  Is it shared irq?

What options did you try with oprofile?

You can try perf -- as long as you limit the functions you profile it should
have about the same overhead as oprofile.  But then you should get about the
same results with either; I just find perf to be a little better these days.

One thing I know of is that all the linear interpolation we do for setting
the power curves is pretty heavy cpu-wise and we do it on every reset.  There's
some low-hanging fruit there like precomputing the reciprocal of some
scaling factors instead of some divisions...

-- 
Bob Copeland %% www.bobcopeland.com
