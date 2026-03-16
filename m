Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C316530AAA6;
	Mon, 16 Mar 2026 02:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773627005; cv=none; b=d6PzyaAD3yopd0iW6YSW3G7VOChXhNfgX3ppCPeIgu9dQvc5v/E5wB1qrAN/lvLSUPHOUVeuZH/28iWTIVY3D/1ETCpronNl3dF0cmmYG9P7KAeg4OydnHIcgHTTcfEdNP+ynEk/uy8y7uj5XvTTfpf866qO56HE6LP2N71CgKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773627005; c=relaxed/simple;
	bh=sed/qnCEK8BKTSNt5bMJKA6V1uhx22zbtT7ew3JC6Vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AyHcqxEK8NGvh2vvaN0Ua6wYIzaU3UkTNy0uhYu7vZu8YXK0YrfDHzyByc6y+FOFpd0zlR9zzMgLwkcxZlunST5k3Is6OgG/oR6u3czQF0HSM1iQLL6B5NtVakJ95g+t+qhE8xpGzHXc8cmcuowGwmRgB9JDZ2FKPsBKhvWykKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nm9Ayc9K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nm9Ayc9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6089C4CEF7;
	Mon, 16 Mar 2026 02:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773627005;
	bh=sed/qnCEK8BKTSNt5bMJKA6V1uhx22zbtT7ew3JC6Vk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nm9Ayc9KSDjebwklqOxZgSSSoD+i8M1cEKIevFRnrIM0Oaa6w3KO3Riyqpu9+IkkS
	 d/QKBANX9pcyP5gFgibm81V/EyFdc+j9YkODkax3tiq1oYbxMg8V+Du7XSlDs1i3YM
	 ZVmJYvbvXNiGfIFj+jzobM/jugz2hV20ABPzUhLyiVnVwmN2Z31FwbHmXoVw92sZ2C
	 xI78x4p+uhHULePySM8KOe7xnlW6Zmu5u4S+kUG6BTD40HZIwL8WHAKq2Yh5T+hbBt
	 8Ehqmea1WT6vbUni0rRKc7bwTIAHGvGoGCkQCmIY8whdDp2hFOUR0i7nTh3JFwzWzZ
	 uDSStEtaSMq9g==
From: Bjorn Andersson <andersson@kernel.org>
To: konradybcio@kernel.org,
	Daniel Lezcano <daniel.lezcano@oss.qualcomm.com>
Cc: linux-kernel@vger.kernel.org,
	Alex Elder <elder@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Kees Cook <kees@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Wesley Cheng <quic_wcheng@quicinc.com>,
	netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	linux-arm-msm@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-sound@vger.kernel.org
Subject: Re: (subset) [PATCH v1 4/8] remoteproc: qcom: Use the unified QMI service ID instead of defining it locally
Date: Sun, 15 Mar 2026 21:09:58 -0500
Message-ID: <177362699063.8490.5627616886098038132.b4-ty@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309230346.3584252-5-daniel.lezcano@oss.qualcomm.com>
References: <20260309230346.3584252-1-daniel.lezcano@oss.qualcomm.com> <20260309230346.3584252-5-daniel.lezcano@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Tue, 10 Mar 2026 00:03:33 +0100, Daniel Lezcano wrote:
> Instead of defining a local macro with a custom name for the QMI
> service identifier, use the one provided in qmi.h and remove the
> locally defined macro.
> 
> 

Applied, thanks!

[4/8] remoteproc: qcom: Use the unified QMI service ID instead of defining it locally
      commit: 95b6c029e56e4d75e2957ce7ac795da29415865b

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>
