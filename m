Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f225.google.com ([209.85.218.225]:56800 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZGFNLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 09:11:09 -0400
Received: by bwz25 with SMTP id 25so1249487bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jul 2009 06:11:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200907040053.05654.chunkeey@web.de>
References: <200907040053.05654.chunkeey@web.de>
Date: Mon, 6 Jul 2009 17:11:11 +0400
Message-ID: <73aaf0dd0907060611w5a288828h4c4728f52fe4e16c@mail.gmail.com>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
From: Max Filippov <jcmvbkbc@gmail.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This patch tries to address a long standing issue:
> how to survive serve memory starvation situations,
> without losing the device due to missing transfer-buffers.

Christian, how does placement of skb allocation point make a
difference? Anyway skb that carry data frame will be handed to the mac
and replaced with new one. That is, this patch does not eliminate
possibility of control frame loss due to insufficient memory.
Maybe we'd better have separate reusable skb for control frames which
is never handed out from the driver?

-- 
Max
