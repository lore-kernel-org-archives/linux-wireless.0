Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2E048986E;
	Mon, 21 Sep 2026 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790008140; cv=pass; b=foScxZkIULugl8XLkSMRxWNdiHfBBjlRY/bECeZmAVUAZNjbzgaWXZi/VLulfyMrb5+DdGcJEurCyqjdFtwZnzDwTpOAIyMYyTplYC/0tjX/Y7eBI+6v4XnUvkuQ70VytL2//d7qyR+Ka+YpG+k6DPH/ExSyMqkeSeyyoUXwbXM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790008140; c=relaxed/simple;
	bh=HthIKG4t4k3A6FmQ5qfFbGeb3MupGvT8gLoDy0k+nYU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=KMMtE6NPuD2gWCQl90S6gFAer6WVUmBfR76MaHLykOJcEt1BtnFk8utAJ+ZyzbOIScNlBkFTVXV42r+pr7g3SPVHVN50izR0VpG7MwuD945yQSTalcPXQrXUNiIPCYVU7P89lrzmTngXg9pzR6e+rWF0KbVZTE/8/Ly3hPksM/s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=mtXfzP/4; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="mtXfzP/4"
Received: from fauth-c1-smtp.messagingengine.com (fauth-c1-smtp.messagingengine.com [204.75.18.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hpTFG57nVzyR1;
	Mon, 21 Sep 2026 19:28:50 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1790008131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t5e0UaYgiorPsh4vDhqkUX8q8sFJG6i6HatLbRVZxtI=;
	b=mtXfzP/4C2htinXFimBpk8Ag9qP+Ktfapg1Z2Ts+EjFzl1ErT33aHCTXr8gsmQDSLKQqYc
	ZI27EL9MVklkjzWWiWIFdvSY7qHmmCYNEyBpiMsooVRQtXMy7crbnEL1QkzWsJKFsoj9ed
	lrasc0BgcUk7YUWGIbsDc/vEpwlYWro=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1790008131;
	b=ON1m2/W06Kkb7pcmKZp0rFzwzp+b5yUpJ3MXiff0sJH8nDBPuECx7DHCtlGQFVoOSag39T
	1L31AiH5MveTImM0vhejukjtOInWhGleRukxA/xAT1YIBlBzeGniltlYiOJ7hiGyjChx/e
	4RMzDpUPdhc8oFk4IzVkq7++HQ4jgao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1790008131;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t5e0UaYgiorPsh4vDhqkUX8q8sFJG6i6HatLbRVZxtI=;
	b=CBmPLV+1UNzBdE73BYq0sLgWPxi1ZHZ/NDtd7Zve3308kFqL6A6WUoCTOEfDwa4FFLbqLi
	yaOpfo/MR5KNl8SXmEEnhaNGDryY4pUICtL9/xD0o4r736Y+zmuw+X2HIQ9ER7GnFLIWtm
	wrMo8Sp/QLvb2GcnAri8vWSAZ8gPiek=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 03D67198004A;
	Mon, 21 Sep 2026 12:28:49 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Mon, 21 Sep 2026 12:28:50 -0400
X-ME-Sender: <xms:PluxapFdnPTsBbay6N6HKMhJhGBTbwFLlmPs96Cv3_wMXCjhv4JjvQ>
    <xme:PluxapLw3n1SIqOAyc9XeXqGMzMMuXZbFHfpDkKS-J8GJhk1HXUs2aY0G6Q7gZER8
    4HHg3Oa7TKlAyp-tkwCv_nPu4KkIipGwBUJZo9eOJe4IcQzqIXFJhVb>
X-ME-Proxy-Cause: dmFkZTEA0pTLxbRa6jupCZWu3EErz1OrCDSyeCVlhXZ7W/sCqaBzg46dX4FuWGAJJoLGPd
    cnz6LrloAAUIROtdaTo5xAf3oEv2WejE8HnP9AtUmnKSeGT3XAPwQCXCpnylw5ykIdA3o8
    jrMgY5tozSrSokeoHnTCJimUFt424HZ8e6gqXocEB3wVmw0Eo7pDbQSvl8XwS54666/C86
    xMDrNbymyxb8LmGteFk9C9RbN9WdMxDmgwAPglctpIkTHVNB/HVJG4EfE2y/R7uTbHXRiP
    bNNECZqyrYwklTwB8Y08RkxcqT5paHCRxOQGc7F/CjzFl0OP7KZ2XZVqOZjAThES47hjGa
    ZOSxwpdi9xrnIDr+s/d5PbOxnX0XtNvFeqhyyIPj7FI9XOrtCtsYjB+NXQTcJQZlGyVpVF
    TTqnrVb/Mq3oQSeStuF4oPXDwH3oWlYvHSNam+jgs5UiLXxmFk4LthQHsVTY26JyOB7Tni
    gaTqSx+bC9A+DVQewDm8QQc0lMfG9Pr27qPgnrwPs6NIp72ubp6lVWSwMsDk58cYhAoYg8
    2EZ7nYa1/iq4WBzvbX+RsnqCZDOmf6sVib2/bwEz5rSIYbehVFhhkui8CKyMcIN5d2zksQ
    KfPpsGnYcidTFzMurNXzffDv5j4z1x37sWFIPinUrC4U4BGZzlDMcP/51sUg
X-ME-Proxy: <xmx:QVuxau20FE2KXcKVX8Kj7yaRBQNe-6jdW3-z6B0Gl2YJzKEoFJPjXw>
    <xmx:QVuxarmelWeufT1RA5Sua8GdBTuPh2yKrXIUZ1qdZYttUe-gyIZBUQ>
    <xmx:QVuxaj1oAI4oJfhj7z5dPwfOEQENof2sSkNsX2xUkL8rI9uZOKzHEg>
    <xmx:QVuxaij3e-1bDlt7IpPqgHWdjKse2jBrfAXwG4_uDOfimIxqDeenig>
    <xmx:QVuxapVvdNvHZDByOswJUsJ16qc8ujprXn-Hb7i1RXjkFhnyN-kIui37>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id E189CF8008B; Mon, 21 Sep 2026 12:28:46 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AtmlxWozq_rN
Date: Mon, 21 Sep 2026 19:28:26 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>,
 "Manivannan Sadhasivam" <mani@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Jeff Johnson" <jjohnson@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Chris Lew" <christopher.lew@oss.qualcomm.com>,
 "Deepak Kumar Singh" <deepak.singh@oss.qualcomm.com>,
 "Raj Kumar Bhagat" <raj.bhagat@oss.qualcomm.com>,
 "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>
Message-Id: <43688c97-deef-477d-8e6c-f293ecccd37a@app.fastmail.com>
In-Reply-To: <20260921-qrtr-multi-ep-v2-3-27dd80d841a0@oss.qualcomm.com>
References: <20260921-qrtr-multi-ep-v2-0-27dd80d841a0@oss.qualcomm.com>
 <20260921-qrtr-multi-ep-v2-3-27dd80d841a0@oss.qualcomm.com>
Subject: Re: [PATCH v2 3/4] wifi: ath11k: Connect to the QMI server belonging to the
 device owned by this driver
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Mon, Sep 21, 2026, at 14:23, Manivannan Sadhasivam via B4 Relay wrote:
> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
> 
> When two identical ath11k PCIe devices are connected to the same host, both
> advertise the WLFW service with the same service and instance id. The QMI
> lookup reports both servers to each device, so a device may connect to the
> firmware running on the other device.
> 
> But now, QRTR provides each MHI endpoint a unique node id which is
> different from the node id announced by the device. So use the same id to
> pick the correct server. Add a get_qrtr_node_id() HIF callback that returns
> the node id derived from the MHI controller index and zero for transports
> that do not assign one. In the new_server callback, skip any service whose
> node id does not match. A node id of zero disables the check, so transports
> that do not assign one keep their current behavior.

Tested-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
Tested-on: 2x WCN6855 hw2.1 PCI WLAN.HSP.1.1-04685-QCAHSPSWPL_V1_V2_SILICONZ_IOE-1

That's from the new rebased patches, v2, applied with git am.

Again, I picked the entire QRTR from net-next/main after your changes,
and backported the ath11k and ath12k changes to 6.6.157 kernel. The
conflicts in ath11k and ath12k are really simple to resolve. The QRTR is
better to take as-is, as it's a large and substantially modified piece
of code, and backporting could risk different behavior.

Unfortunately, it seems I'm locked to 6.6 kernel until I manage to boot
a newer kernel. I tested 6.12 series and my perfectly valid gzipped
initrd ext2 file system is recognised as gzipped, but mounting the root
from /dev/ram0 fails due to -EBUSY. Why this happens with 6.12.x but not
6.6.157 is a mystery to me. Prompting two AI models didn't help, they
keep on just repeating the same useless points. So I have to resort to
heavier weapons, printk and maybe even git bisect.

So, because 6.6 kernel in our CPU doesn't work with ath12k due to lack
of interrupts and I can't boot a newer kernel yet, you'll have to either
find someone with two ath12k cards, or just accept to test the ath12k
change with a single card and hope for the best.

My understanding is that 6.12 would support just 1 interrupt in ath12k.
If I could only boot it, that is.

BR, Juha-Matti
