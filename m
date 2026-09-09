Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A555328A0;
	Wed,  9 Sep 2026 10:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.145.95.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788951104; cv=none; b=m19iN6Z3GInsJplc4EfNRDGvKzGuuA/m2X4Xj+Q851+UMC37Joyw6tk0DzvX3urCtcy7UzX4V1rc8s8HfTF1qoLgMSPN0euqqQDsPTMPABIpjCrdmj1QFgvsqU8CXm4XnDlPoZ/txnBRQSOJeLBUWc6DsNHPc4DJ6SwjJipHsfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788951104; c=relaxed/simple;
	bh=HOk3yh146JcW8dTSrTD41owtnh1AfmKTyEa91IOs1Sk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cd3h+rj+Hz4XEJ3Q4mia+exN+9tCk9WtV4plxjKj4RhFau7eYC1MutWtw25OtJBE/31c8R9hzESSgBuxfBtpb/eCAXQdhmeyVHWEIUhQzXdl7SAsx5aGk3QVjuqaXGPjt0lYe1Qo4qrTGpn1AkmERvAIiCfeiDZcK2K1oQDbyW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk; spf=pass smtp.mailfrom=toke.dk; arc=none smtp.client-ip=45.145.95.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, Pengpeng Hou
 <pengpeng@iscas.ac.cn>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: ath9k: validate WMI response length before copying
In-Reply-To: <42e9f2c5-7ba5-4270-91b9-46c41526c065@oss.qualcomm.com>
References: <20260704011405.55089-1-pengpeng@iscas.ac.cn>
 <87wlt1tizn.fsf@toke.dk>
 <42e9f2c5-7ba5-4270-91b9-46c41526c065@oss.qualcomm.com>
Date: Wed, 09 Sep 2026 12:51:38 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h5jyg0jp.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jeff Johnson <jeff.johnson@oss.qualcomm.com> writes:

> On 9/4/2026 3:21 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Pengpeng Hou <pengpeng@iscas.ac.cn> writes:
>>=20
>>> ath9k_wmi_rsp_callback() removes the WMI command header from the skb
>>> and then copies wmi->cmd_rsp_len bytes into the waiting response
>>> buffer.  The response length is expected by the waiting command path,
>>> while the skb length comes from the device response.  A short response
>>> can therefore be read past the end of the skb data.
>>>
>>> Record malformed short responses in the WMI state and return the error
>>> to the waiting command path after completion.  This avoids both the
>>> out-of-bounds read and the false-success case where callers would
>>> consume stale response data.
>>>
>>> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
>>=20
>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> Can you check the v2: 20260814075837.20005-1-pengpeng@iscas.ac.cn

The code seems to be identical, only the commit message differs, so up
to you which version you want to take :)

-Toke
