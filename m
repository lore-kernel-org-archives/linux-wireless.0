Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4FFF351C30;
	Sun, 12 Apr 2026 20:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776027509; cv=none; b=LWmwRtbpzoEB+4l3faBB7XYdV1js9cw83DrMO7nPrvqDt2U6X90ug0NfB+68JLpRbieIA+7+VBxp2NQLGLo5SgT9rCvvgKIzEo+rpkesI4GXo0dN7ezjbl3ICHUbYgixg9U+Izygm8a84UocUKEmMjPCQVLNPNg0E3vZmGAJHhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776027509; c=relaxed/simple;
	bh=UuQrIK1aHRDtycvnWsa1Fwi8cjQTRLCMiv417Myy+ds=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CdYvbaMkAcvh5p8Z05ffkss+F8gbCyrrCFX7EDQGg0zqhem1/xfG/Zq5FU6qinqDFd+SGBecDjIJTVmWfpqiQjGq+bN4F+esvqfeU71J+uX8fGS+/Talv7HRN1N0VMV1C0xGEKFkcL5tsl+vBeUDrAwePVgl8eecKDyraq+1rMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EirTS/vN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EirTS/vN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F71C19424;
	Sun, 12 Apr 2026 20:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776027508;
	bh=UuQrIK1aHRDtycvnWsa1Fwi8cjQTRLCMiv417Myy+ds=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EirTS/vNi0+PFAF/vsi/uXnaMv1Dz1SMdJRU/B+gZm/HCLWTakhjvnr8k6znCwm/D
	 QQsFkOdoasjSYryQKWj7hplaHhzfabTVxVEiv+3op45wbabHAMdLu88gKPotGp3t+o
	 pbtMfF8rtsGlLyDs77eBUBYVKdQAMamioPCVrQBnHIZ8Nh0TNfXcreYH7+1N+IZse9
	 MUg/L1ZrgrjNEpzM4ZR4oDEkBLNc0IviWWbsoi/HGIsJIzOVKurqqYGvwflFPECJP7
	 12IpAS/Q9AkPx2wBu7zS0vPrBcYAYN0BB4Szhr9J7TCK4fTUE6qYKaiZDGLUFRGq6D
	 xihgY1kW11bcA==
Date: Sun, 12 Apr 2026 13:58:27 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: =?UTF-8?B?TGVrw6sgSGFww6dpdQ==?= <snowwlake@icloud.com>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
 stable@vger.kernel.org, krzysztof.kozlowski@linaro.org
Subject: Re: [PATCH net 1/4] nfc: digital: Fix stack buffer overflow in
 digital_in_recv_sensf_res()
Message-ID: <20260412135827.0cb6f44c@kernel.org>
In-Reply-To: <20260409223436.1887988-2-snowwlake@icloud.com>
References: <20260409223436.1887988-1-snowwlake@icloud.com>
	<20260409223436.1887988-2-snowwlake@icloud.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Apr 2026 00:34:31 +0200 Lek=C3=AB Hap=C3=A7iu wrote:
> The function digital_in_recv_sensf_res() validates that the incoming
> SENSF_RES frame is at least DIGITAL_SENSF_RES_MIN_LENGTH (17) bytes,
> but does not check that it is at most NFC_SENSF_RES_MAXSIZE (18) bytes
> before copying into the 18-byte target.sensf_res stack buffer.

Hm, third similar fix we received for this.
struct digital_sensf_res is 19 bytes, you're capping the length at 18
something else is wrong here..
