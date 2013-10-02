Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:41299 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab3JBLSN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 07:18:13 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so261775bkb.3
        for <linux-wireless@vger.kernel.org>; Wed, 02 Oct 2013 04:18:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1380707467-30387-1-git-send-email-michal.kazior@tieto.com>
References: <1380707467-30387-1-git-send-email-michal.kazior@tieto.com>
Date: Wed, 2 Oct 2013 13:18:12 +0200
Message-ID: <CA+BoTQnQVE_YUrrtfFCeQSj4tmccbA9cG_ZMdHisx4C-mJfqkg@mail.gmail.com> (sfid-20131002_131817_127609_ACC32CEE)
Subject: Re: [PATCH] ath10k: fix scheduling while atomic bug on config
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 October 2013 11:51, Michal Kazior <michal.kazior@tieto.com> wrote:
> Recent WMI/HTC changes introduces this bug because
> now WMI commands can sleep.
>
> Use appropriate interface iteration function.
>
> Reported-By: Kalle Valo <kvalo@qca.qualcomm.com>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Self NACK.

I've posted this too soon. This patch can lead to deadlocks on
iflist_mtx in some cases.


Michał
