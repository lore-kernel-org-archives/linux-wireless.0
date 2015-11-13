Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56912 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932363AbbKMLh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Nov 2015 06:37:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Borja Salazar <borja.salazar@fon.com>
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	sujith@msujith.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH v2] ath9k: incorrect queue may be stopped/awaken
References: <CALhHN=ov0kqqgGGHwPMOq3VaVsg9oD59Ed_NNsdcKVyS2+go2Q@mail.gmail.com>
	<1447410786-31874-1-git-send-email-borja.salazar@fon.com>
	<CADqurOFRewt0OTU_HSCozBfmQBy53Q2DBs2vKkfw29O+pZeR7w@mail.gmail.com>
Date: Fri, 13 Nov 2015 13:37:18 +0200
In-Reply-To: <CADqurOFRewt0OTU_HSCozBfmQBy53Q2DBs2vKkfw29O+pZeR7w@mail.gmail.com>
	(Borja Salazar's message of "Fri, 13 Nov 2015 11:49:13 +0100")
Message-ID: <8737wa2kr5.fsf@kamboji.qca.qualcomm.com> (sfid-20151113_123742_960668_9E99A0CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Borja Salazar <borja.salazar@fon.com> writes:

> Let me explain the patch more thoroughly. We are testing MCC and we've
> found some issues with the queues handlers, the main problem is that
> when we transmit a multicast/broadcast frame, where hw_queue is 8
> (CAB), we check queue status, which is 2(q), and if it is full and we
> have to stop it, we end stopping the wrong queue, 8, which is not
> full. From this point onwards stations are unable to connect to the
> AP.

This information should be in the commit log.

-- 
Kalle Valo
