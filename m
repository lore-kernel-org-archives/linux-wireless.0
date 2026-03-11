Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96F8921D585;
	Wed, 11 Mar 2026 05:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773208070; cv=none; b=a4syRR2mHgSkZRft1xKUoB5NezseUpg7lY8sHIfzc0hzpDK5IhI4n6+wS+JUtHQc/o3YE05pVjzcO5JkgFJGJfxeZxX56l9P/H3pNByFkRCKRvP2C2TzoytNewshCnk38gPav0vpmkcNjMtrWUBjzP+UUb3kslNMEcksV8RzPCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773208070; c=relaxed/simple;
	bh=vtEXOBuhUMjTZiyrtnPZqy/gdjvwakJ6MHrQOKgG2i8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LIj6QIgG4UsxEIXj3kIpeyzS2hBewsr/E3oPAJczjjdw9OspHJH+UauWda/klKQjSYChgY7RgUhekijxUiEBjeTZld+q5ZtUw3cuUzDpFnXBU7iSKvQ436txxdFwebhZB9emw0J1a4F/BxCgRTyAGRzNWSpsSbSAJj1tjd5ZE38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeACOq6z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeACOq6z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0823FC4CEF7;
	Wed, 11 Mar 2026 05:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773208070;
	bh=vtEXOBuhUMjTZiyrtnPZqy/gdjvwakJ6MHrQOKgG2i8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eeACOq6zvoHImfK89PKpnKoKhq+cOkbQunVao4m97OtiMRTKtqFh5GxPIPgTjIpgy
	 rnEXWEaYqXoVPz5ELjFYeO/OHfGGLDfvzbsGPzhxhIrkh68hW1CJRR4AMqK4s5A/36
	 ld6d79lXYRX/UiVqfoGxjiJVtOw0GGYKcTa1YqzSjiSiJyZy/VAFq8tCU6CqG2b/NJ
	 SZNPygMIjEB2PBNtAIG1KJvpM2Btaw4YdDzp40appRQ5TQ/cLfng+o6eD2SfNbyA4Z
	 Rq3gIQ30dMyREadAFPWCHwvu/KXM6SPAK0Tl7Sju6ZCSdtME89zS08zVLG6HUh3nuc
	 aib8sP4ePsXng==
Date: Wed, 11 Mar 2026 11:17:32 +0530
From: Sumit Garg <sumit.garg@kernel.org>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Jorge Ramirez <jorge.ramirez@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
	linux-media@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath12k@lists.infradead.org,
	linux-remoteproc@vger.kernel.org, andersson@kernel.org,
	konradybcio@kernel.org, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, robin.clark@oss.qualcomm.com, sean@poorly.run,
	akhilpo@oss.qualcomm.com, lumag@kernel.org, abhinav.kumar@linux.dev,
	jesszhan0024@gmail.com, marijn.suijten@somainline.org,
	airlied@gmail.com, simona@ffwll.ch, vikash.garodia@oss.qualcomm.com,
	dikshita.agarwal@oss.qualcomm.com, bod@kernel.org,
	mchehab@kernel.org, elder@kernel.org, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, jjohnson@kernel.org, mathieu.poirier@linaro.org,
	trilokkumar.soni@oss.qualcomm.com, mukesh.ojha@oss.qualcomm.com,
	pavan.kondeti@oss.qualcomm.com, tonyh@qti.qualcomm.com,
	vignesh.viswanathan@oss.qualcomm.com,
	srinivas.kandagatla@oss.qualcomm.com,
	amirreza.zarrabi@oss.qualcomm.com, jens.wiklander@linaro.org,
	op-tee@lists.trustedfirmware.org, apurupa@qti.qualcomm.com,
	skare@qti.qualcomm.com, Sumit Garg <sumit.garg@oss.qualcomm.com>
Subject: Re: [PATCH 11/14] media: qcom: Switch to generic PAS TZ APIs
Message-ID: <abEB9DiHs6JLVRnp@sumit-xelite>
References: <20260306105027.290375-1-sumit.garg@kernel.org>
 <20260306105027.290375-12-sumit.garg@kernel.org>
 <aa6O5tir4kVIe0eZ@trex>
 <a96cca02-54e4-4ed0-9fcb-816c72afe0e7@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a96cca02-54e4-4ed0-9fcb-816c72afe0e7@oss.qualcomm.com>

On Tue, Mar 10, 2026 at 12:18:29PM +0100, Konrad Dybcio wrote:
> On 3/9/26 10:12 AM, Jorge Ramirez wrote:
> > On 06/03/26 16:20:24, Sumit Garg wrote:
> >> From: Sumit Garg <sumit.garg@oss.qualcomm.com>
> >>
> >> Switch qcom media client drivers over to generic PAS TZ APIs. Generic PAS
> >> TZ service allows to support multiple TZ implementation backends like QTEE
> >> based SCM PAS service, OP-TEE based PAS service and any further future TZ
> >> backend service.
> >>
> >> Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
> >> ---
> 
> [...]
> 
> > are the calls to set_remote_state required?
> > 0 is not the IRIS/VENUS remote processor.
> > 
> > If it is legacy, maybe they can be phased out?
> 
> FWIW, in msm-3.10 (yes) QCOM_SCM_SVC_BOOT/0x0a used to be called
> 'TZBSP_VIDEO_SET_STATE', taking the arguments:
> 
> args[0] = suspend->0, resume->1
> args[1] = spare=0
> 
> seems like sdm845/msm-4.9 still had that and so did 8250/msm-4.19

I would assume passing actual PAS ID in that spare argument shouldn't
cause any issues for QTEE as it could just ignore that. Let me try to
see in my testing on RB3Gen2 if it causes any ABI issues. Since with
OP-TEE we would like to not deal with ABI inconsistencies.

-Sumit
