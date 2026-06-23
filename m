Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 214CE2475CF;
	Tue, 23 Jun 2026 12:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782219501; cv=none; b=aZQlQbrKdP3oIK9W8b263ZeASnsvN4nIy/qsNmPgFCJqDWk9/LVImFA1VlHIrTZQuqN6uY0BJUBfajE2q7fPETn+ZrY0NIwq4F0bq6C7uvnklOjY8McVj4fjdaZLpxcHvKAddjdGiZY/rxv/wMvJY4rzjzJQHYdWQhtrTa+n1Gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782219501; c=relaxed/simple;
	bh=pK4Q9YJv3ZwX9pxCMd8QUz9TNHTZr/RDJ40f11iJ9XM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=KetyC6TBPqk3sOKFNveQFCObQFRlGkhL4xSIAvrS8+lldkS2sCqVCAcUP/ECoaFsknOoV2maRb87+fLA3dvWCvVfAnSuNm8+ymVE+SsInAHqLNNGBhrzsufYsrXBCrMMqzovOMYc+EBbWFZjUP88X7+WrmZEiQT4fbljUPuizCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Authentication-Results: mail.toke.dk; dkim=none
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 ath-next] wifi: ath9k: mark static arrays as const
In-Reply-To: <CAKxU2N-bku8uZJ2nqtXb5nMhaPpxYnHqefNBj=WWe6HeKRaBXA@mail.gmail.com>
References: <20260619175210.5348-1-rosenp@gmail.com>
 <87se6eeqwn.fsf@toke.dk>
 <CAKxU2N-bku8uZJ2nqtXb5nMhaPpxYnHqefNBj=WWe6HeKRaBXA@mail.gmail.com>
Date: Tue, 23 Jun 2026 14:58:10 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <871pdxe7ml.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Rosen Penev <rosenp@gmail.com> writes:

> On Mon, Jun 22, 2026 at 4:49=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@toke.dk> wrote:
>>
>> Rosen Penev <rosenp@gmail.com> writes:
>>
>> > PN9Data is a read-only lookup table and is never modified.  Adding con=
st
>> > lets the compiler place it in .rodata and prevents accidental writes.
>> >
>> > Use the same treatment for bits_per_symbol. It's not modified either.
>> >
>> > Assisted-by: opencode:big-pickle
>> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
>>
>> Again, which actual bug are you fixing here?
> Patches are required to be bugfixes?

Well, or at least have some concrete benefit? You're changing working
code here, we've had to revert patches of this kind before because it
broke things.

For this patch specifically, there's one of two cases:

- The array is never written to, in which case the patch has no
  practical effect

or

- The array *is* actually written to somewhere, in which case the kernel
  will now crash as soon as someone tries to run the code.

Either way, I don't see how the risk/benefit tradeoff comes off positive
for this patch?

-Toke
