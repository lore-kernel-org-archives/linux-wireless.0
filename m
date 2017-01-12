Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:49059 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750755AbdALLLk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Jan 2017 06:11:40 -0500
Subject: Re: [PATCH 6/9] rt2800: fallback from mcs8 to mcs7
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        linux-wireless@vger.kernel.org
References: <1483707918-31480-1-git-send-email-sgruszka@redhat.com>
 <1483707918-31480-7-git-send-email-sgruszka@redhat.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Mathias Kresin <dev@kresin.me>
From: Felix Fietkau <nbd@nbd.name>
Message-ID: <e3c3f693-3d34-ecfc-de13-855c1d75b849@nbd.name> (sfid-20170112_121220_558522_76BB891C)
Date: Thu, 12 Jan 2017 12:10:48 +0100
MIME-Version: 1.0
In-Reply-To: <1483707918-31480-7-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017-01-06 14:05, Stanislaw Gruszka wrote:
> If we do not fallback to lower rate, we are unable to calculate
> correctly number of retries in TX status code.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
I think falling back from the lowest dual-stream to the highest
single-stream rate is a really bad idea.
Instead you should get rid of the assumption that fallback rates are
ordered by their MCS index.

- Felix
