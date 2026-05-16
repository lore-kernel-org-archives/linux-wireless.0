Received: from gollum.nazgul.ch (gollum.nazgul.ch [82.197.176.155])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D10D3CF043
	for <linux-wireless@vger.kernel.org>; Sat, 16 May 2026 11:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.197.176.155
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778930946; cv=none; b=ZGefeVSLf2dV9lyhTkzyN2ZxP5c0zx2mVygyXyQ6bAMHJIhkSmDBdm5DYhyZboqj/GI4ukmshGA1/iA039o1/l4RM0WZw32XfLxzYZWSJ3vyAWBgqmZeXJDxP61P/lLKCHvogfHRmxWfRmxEc3vKinrSJllVzXlJ7Ljc9dWLJ5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778930946; c=relaxed/simple;
	bh=992DBl48OGUizMmAn48mg1AQqW5a+TPeNno80dNlk6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bewzgysikov4zvfypBzPO3Nu+h8tYYIZdZJ+3/XjGLbPHY5boTz4Xgcswt8Iqxo7AbjVSznUMtFWEcpfgQ0DxdWMbCWcQzSZBkOtCzZG2Yr333J+hFJ3Eva5UX908Kkc39kNpHSp+jDmMFcoIhWOROGBjhQ6l/ttzzEN7oxNFUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nazgul.ch; spf=pass smtp.mailfrom=nazgul.ch; arc=none smtp.client-ip=82.197.176.155
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nazgul.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nazgul.ch
Received: from localhost (gollum.nazgul.ch [local])
	by gollum.nazgul.ch (OpenSMTPD) with ESMTPA id 54103abb;
	Sat, 16 May 2026 13:28:54 +0200 (CEST)
Date: Sat, 16 May 2026 13:28:54 +0200
From: Marcus Glocker <marcus@nazgul.ch>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, 
	Jeff Johnson <jjohnson@qti.qualcomm.com>, Can Erkin Acar <canacar@gmail.com>
Cc: Maxim Storetvedt <m.tvedt@tutanota.com>, ath12k@lists.infradead.org, 
	linux-wireless@vger.kernel.org, jjohnson@kernel.org, kvalo@kernel.org, 
	Mark Kettenis <mark.kettenis@xs4all.nl>
Subject: Re: ath12k WCN7850: Q6 Hexagon fault at WLAON region 0x1792000 ~2s
 post-AUTHORIZE on X1E80100
Message-ID: <qjzrnkxn5qjbdw6wwwxs5eigktut2ivsguoqbvejssqkuhadxx@iwahnswwhu57>
References: <g7dkeq3uwg7eby57zcuu5eysf4tqomh5civlvkpnlziipn6xis@45eevyzgfmaq>
 <0b450204-9afc-4ba1-b9c5-1876b5a7078a@oss.qualcomm.com>
 <tzkh5t3bmiqff67g72rihapizz2u2dlj4xfrr324d6yg4rtltt@3qrsymzw7c2c>
 <92ace4b9-143e-4962-90fa-215a22e24796@oss.qualcomm.com>
 <cz6dbqafvulifyrefsxzwrlq5z5uojylphqkq5oydbn2bvcns5@bhj3hr2rvxhq>
 <fxrzvhcrbkugzfzmj6h5netczccav5hxfefzyns67t5jhakk5w@pp6addxjkdb2>
 <0ef41d1f-e9ec-4f90-9f6a-77cb8fa3a7e7@oss.qualcomm.com>
 <yjintdxwvtkgpehyjdtrs4wdwfli3c2vdyp2bweiauwssywjl5@srrtguf5eq4i>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yjintdxwvtkgpehyjdtrs4wdwfli3c2vdyp2bweiauwssywjl5@srrtguf5eq4i>

On Thu, May 14, 2026 at 07:20:51PM +0200, Marcus Glocker wrote:

> Hi Baochen, all,
> 
> On Thu, May 14, 2026 at 09:55:30AM +0800, Baochen Qiang wrote:
> 
> > > With that fixed, the firmware error is gone, and we can now receive
> > > and IP from DHCP.  We're working on getting the TX path work next.
> > 
> > OK, good to see it gets fixed!
> 
> Since today we also got RX/TX fixed, so we have now an initial working
> ath12k device with our qwz driver on OpenBSD.
> 
> What is still missing from the firmware side;  The PCI-id of the
> WCN7850 chip included in the Samsung Galaxy Book4 Edge isn't included
> yet in to the Linux firmware package.  I've addressed this a few times,
> but unfortunately no feedback.  That's the additional PCI-id line
> which is required for the Samsung Galaxy Book4 Edge:
> 
> --- board-2.json.orig	Sun Apr 26 08:06:37 2026
> +++ board-2.json	Sun Apr 26 08:07:45 2026
> @@ -160,7 +160,8 @@
>              {
>                  "names": [
>                      "bus=pci,vendor=17cb,device=1107,subsystem-vendor=17aa,subsystem-device=e0e6,qmi-chip-id=2,qmi-board-id=255",
> -                    "bus=pci,vendor=17cb,device=1107,subsystem-vendor=1eac,subsystem-device=8003,qmi-chip-id=2,qmi-board-id=255"
> +                    "bus=pci,vendor=17cb,device=1107,subsystem-vendor=1eac,subsystem-device=8003,qmi-chip-id=2,qmi-board-id=255",
> +		    "bus=pci,vendor=17cb,device=1107,subsystem-vendor=17cb,subsystem-device=1107,qmi-chip-id=2,qmi-board-id=255"
>                  ],
>                  "data": "bus=pci,vendor=17cb,device=1107,subsystem-vendor=17aa,subsystem-device=e0e6,qmi-chip-id=2,qmi-board-id=255.bin"
>              },
> @@ -202,4 +203,4 @@
>              }
>          ]
>      }
> -]
> \ No newline at end of file
> +]
> 
> With the resulting 'qwz-wcn7850-hw2.0-board-2' firmware board file,
> we have now proved that the ath12k driver is working with Linux and
> OpenBSD on the Samsung Galaxy Book4 Edge.  Maxim Storetvedt did test
> with Linux.
> 
> Given that, would it be possible to include this PCI-id to the next
> linux-firmware package?
> 
> Thanks and Regards,
> Marcus

Hi Jeff, Can,

Could you please help me with my above request?

Thanks,
Marcus
