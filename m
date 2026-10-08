Received: from mta0.migadu.com (out-204.mta0.migadu.com [91.218.175.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6298F31B80E
	for <linux-wireless@vger.kernel.org>; Thu,  8 Oct 2026 05:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791437813; cv=none; b=FWWqZVxtVo3ClcF8KkluaDA/onPyeTEC/eHjxf6snF7tYRoAOxFHhatsXr3g6roEiUYOzY1deh4h0DT893S1TQYxB17ejek8dYOA14ooI856tF+0AXptlIylStudrgYCUZfge4zpeU68iurBwXVRehFczqCqeBdvpuq5yXLgLfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791437813; c=relaxed/simple;
	bh=DdNJNhz3vn2KhGxmjHfY/USjOcTnTIlKlkBaZn8kXqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gd6p04CpwpkZj0/r9U+DVqH21HKF7Fb0zkmQ+8pOOsBsrSt7kb7R5eZ2f+ThadDiPbmvAEHOh4KArxHy1r9L7ig6FECNRIfEkHaJzlAFtHtl/Go8QySTixyTZpbB66a0uddO+QgwpIUF4lHBKm+PL6+t+rHsdK0zt9ylf75zYQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=vIn1Ba9P; arc=none smtp.client-ip=91.218.175.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="vIn1Ba9P"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=DdNJNhz3vn2KhGxmjHfY/USjOcTnTIlKlkBaZn8kXqE=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791437809; v=1; x=1792042609;
 b=vIn1Ba9P8/5sNw9hhAoou7BJbC0ChwqBMtcU3FMGlBLAZqSQfZdK9HnCWiAtTiYQcpq+X8/e
 ATU3R04og1jwDtxCmaaRs9cwlCRI7CTflD0hOdroJRD3a1bQIObE/RzAtL6R9Y0/d7OMLuTe++Q
 CQKX4DoPbgtCqxsbAhHGI0l+AxI5JMRToMp8EEkUKIsp0wkSptjbvf0JXX/tMw3QRhqFKk0M8vy
 YARt5i78hWqMU+F1DdMcHnxgP8rRtSqaYfZFbdMrmfXN62hXT3UnA9SKBMmuk599wxvivcVAh9X
 lDqupLoIGQqc/XUBbyDo/FNxe8KwRffrDRDTZQx4lSplQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 21e88774936a089f;
	Thu, 08 Oct 2026 05:36:39 +0000
X-Mizu-Trace-ID: 21e88774936a089f
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Chris <hoopyfrood42@gmail.com>,
	linux-wireless@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Sean Wang <sean.wang@mediatek.com>,
	Deren Wu <deren.wu@mediatek.com>
Subject: Re: [BUG] wifi: mt76: mt7925u: survey busy time is 0xADBEEF per update, booked to a stale channel (monitor mode)
Date: Wed,  7 Oct 2026 22:36:36 -0700
Message-ID: <20261008053636.81286-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <CAHaeJsSM2kg6undbwaMUwcBbrA500CxMShU=VHv7w1B+YefHiA@mail.gmail.com>
References: <CAHaeJsT8O8Nhq351hFp3NAL8e0iU85N-LBdYZ9nYHFHVy7t_hQ@mail.gmail.com> <CAHaeJsQ3FxvU1dQTSP751-Jq8JVv-tS8oRhNhuVy5-U4kPXwrA@mail.gmail.com> <CAHaeJsSM2kg6undbwaMUwcBbrA500CxMShU=VHv7w1B+YefHiA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> You clearly know this driver well, so I wanted to ask whether you
> would be willing to look at it:

Thanks for running v2. I took the busy half to an A9000 here.

The firmware answers the MIB query at every offset from 0 to 255. Tx
airtime is offset 28. Offset 29, which mt7996 reads for rx airtime,
moves with receive traffic but at a small fraction of five others that
agree with each other.

                 uplink      downlink
    offs 28   +16082143      +3708623
    offs 29       +8749        +81107
    offs 17    +2925971     +12992696
    offs 20    +2852775     +12903656
    offs 90    +2931365     +13006210
    offs 92    +2751610     +12969276
    offs 95    +2863941     +12908314

    20 s at 836 Mbit/s up, then 20 s at 581 Mbit/s down

Deren, Sean, Ryder, Shayne, if you have a moment, could you please say
which of these carries receive airtime on mt7925? And if an MCU command
enables the IPI histogram, I'd appreciate a pointer. Nothing in the 256
offsets has that shape, and Chris's write to those registers wedged his
chip.

The same MIB registers work on an mt7921, so any fix has to be
conditional on the chip.

Devin
