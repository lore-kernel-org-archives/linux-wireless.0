Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793633036;
	b=4RA5l4sxbpKO6NTN/YeFynGR/3dbW2sexhzCTpJXe6L/QLCVv1Ua7RRxXq+Lo0BQvyuD
	 rB5f0xxC0B0m8OXpgVoqpXGeFl3MFN0d/wL8ctnGdUwOd6wwBMzIpHOVoHR8nu3Kw8Tqf
	 EOD+/DCVpV5PlIBZh2gnpLmsxQUHNOyXH6wuNOjvRnE/S1WaVo2xn9JFrYqU99SxP8pip
	 Gb7vvZQm1iZth5wXjMsvsG4xZwrxItk+vp9fI29JbFpwVRHb0dkiiW67Xg6FJcgUzz6Nk
	 JP9wwErOHfMc+asAWh4CUjR/vgC7YButCIeEgQGWchOIraoj+A4dNsDVhHbQOdFiKpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793633036;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:X-ThreadId:Date:From:To:Cc:Message-Id:In-Reply-To:
	 References:Subject:Content-Type:Content-Transfer-Encoding;
	bh=uEqaClazRJnTsShq1vBrZThkV8Ug5LupXRrZvH3pubU=;
	b=zWhPyqyASttdLxOntEae+M/qPNNTAsJPVQaN5PDMACXfedGRqIYLTY55K34GSoXazqt9
	 gw9Qv+YXy53kgAr3qtpZDdpvBbMbkwPNqq6nAv48nPXbB5CBDzjtsxzVW40XzPPiyUcbP
	 aM8H9pDBiSyQeOg6pkc51p+Lf7lLZ45paA31+Jxb4skiC6cnSJX6dkWmPfkE/Fflg9jpb
	 0BN9FBeAigutxymshRXGaofjA3t/JTBWPM5RcrJD6C0Mcp9ZlJi4k6vfPORl2kCcTBIdz
	 jTfRUBMxK78Zsd7K9Mu7pdLtCvYVzk6DOCMpv2cED7cPvi2KV4ougzxN7U73L3DgFAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIuFSq1P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AD36085548;
	Mon,  2 Nov 2026 15:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mIuFSq1P
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E743E1F00A18;
	Mon,  2 Nov 2026 15:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633036;
	bh=uEqaClazRJnTsShq1vBrZThkV8Ug5LupXRrZvH3pubU=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=mIuFSq1PlqlmdXFERDfJN7xR4u5IteXp36sTNLjKWlJ3PZnCQ7SxQ9Z8UCzZ7AanN
	 iTmqIsunzoLf+JESfRKnC6la/SKJxEuECOpRC4m1mxKYtEENio0cNrBZUlwv3Cn1Ju
	 L2XFtAU7btTAXTmXfpiP5OkuJisO8o5FmbxPihb3qHbPYYt4d453+VAim5KWoAkSC1
	 2Fd2p2kx4civ6GaWE+BpkvgbroPeNB4ah0yvOL6NMa8rqhP8u7cH4Eg9ASUb8RI7kj
	 qI+8C0unnQ6K3AeeETs1U50pgWSgQSyPvNAk7jX6tB3K2RdFAf3cHrAEBzOw47122Q
	 VJsWYwf7xqfVw==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id 382B4F4006C;
	Mon,  2 Nov 2026 10:23:55 -0500 (EST)
Received: from phl-imap-15 ([10.202.2.104])
  by phl-compute-10.internal (MEProxy); Mon, 02 Nov 2026 10:23:55 -0500
X-ME-Sender: <xms:C6voarBG_46XohCXRntvrxLbooo2QsSdsnLFLdxSrHV4W9Jb2ut0Ag>
    <xme:C6voasUMAuId_-ti7Q8S8IF3BK3PvETtGHUiz2GmeX_VR2_ioD8Q6fx_GbSfksvIr
    qG4dMA_l9cKm_ncenleFZKDIuWdoyF99hMQQDP57vDZlDT7EPia0kk>
X-ME-Proxy-Cause: dmFkZTEuDKpUtgQyi2eOiDg2o6TUoTp2bk7lhmwIPo3Kl4qs+offfHvEJk9aR2DF91KXsE
    Jxidsa0Y3Asgn0aI5aOrM2Max7nkEDOzg4YXDG4G6tfBqS9nJmQJLt2f9/W5jedW2Vqyrj
    vWHoA3rhMdqZxwN2oaC/EtCoAdPIv77w4Tq354CApiiB5VaFPsD3X3KLXByZkxu/RJiM4y
    FnF5cunvfo1SRG3wbosdIg/eculXH61Ef0aQTnpoZMqrZpo1TmCYaW2E3zfp6ZHOWWRhNl
    sSH0iQPYh6Dq40Tk6wheD3GNPHTWWdqaAKBANmOB2Enmckt3/kZ+HMlA3CIqeCJ797tSAC
    jAzzukG1rQZK6BqPQvJ72fqAFjBqNPdDa1VjBSesM8MZdxT6ZX+/XYeFSible6dm/uDGuH
    hOjkvlOJMsXjBRKb/5uxacYLSimlY+2LlXnywzd4/nICRoDdJCwSCQ9jV4fJpec9dsnExs
    MyRDfwan+mAx6RuiehQKCHL5UdeluCv0jlYidViIVf0MsLi6dFHffPfd603NFQOFJI4AAh
    Qgzdc53z4AHK0m2BgFJhY/Qeag3jbDkkn/+luM73w4teeGrhCRLr93RIQ/VfnthZ/b088S
    /XvTSHYqxiXCzggzR02dTJHyNdXuEnyC1Amk34GMDL4U4u7zk2bKqX83/RmA
X-ME-Proxy: <xmx:C6voaunxJFKq8UoErlxZKFXyzuu9b8iSXHFLsTXrqRTTepkTydh7dw>
    <xmx:C6voauBmUP5nBlBxmlCRHgPmBPFmK_EA6sB3y6XPb8q3EOCa-i0CtQ>
    <xmx:C6voaoPPoyRKLKeYFrAjOz84wGTys2RJMDRlVIVsyk3c9ItGRe5EKQ>
    <xmx:C6voatOSaw-2SBJKZRQ1ReC7HUnfj0Jszj08rAjFrI3xsKZEArL1tQ>
    <xmx:C6voaolZiYJP2EGJHvyOTu5KDle09EOyVGOLTHSxtJmyBMZQLyTKW890>
Feedback-ID: ifa6e4810:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 15863782738; Mon,  2 Nov 2026 10:23:55 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-ThreadId: ArOOpyqnvtx-
Date: Mon, 02 Nov 2026 10:23:34 -0500
From: "Chuck Lever" <cel@kernel.org>
To: "Christian Brauner" <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
 "Jann Horn" <jannh@google.com>, "Josef Bacik" <josef@toxicpanda.com>,
 "Chris Mason" <mason@kernel.org>, "Jeff Layton" <jlayton@kernel.org>,
 NeilBrown <neil@brown.name>, "Eric Dumazet" <edumazet@kernel.org>,
 "Thomas Gleixner" <tglx@kernel.org>,
 "Alexander Viro" <viro@zeniv.linux.org.uk>,
 "Jonathan Corbet" <corbet@lwn.net>, "Christoph Hellwig" <hch@lst.de>,
 "Greg Kroah-Hartman" <gregkh@suse.de>,
 "Joel Granados" <joel.granados@kernel.org>, "Kees Cook" <kees@kernel.org>,
 "Jan Kara" <jack@suse.cz>, "Jan Kara" <jack@suse.com>,
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-s390@vger.kernel.org,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org,
 "Linuxppc Dev" <linuxppc-dev@lists.ozlabs.org>, netdev@vger.kernel.org,
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 coreteam@netfilter.org, kexec@lists.infradead.org, linux-pci@vger.kernel.org,
 linux-sound@vger.kernel.org, netfilter-devel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, ibm-acpi-devel@lists.sourceforge.net,
 jfs-discussion@lists.sourceforge.net, linux-alpha@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-fbdev@vger.kernel.org, linux-hwmon@vger.kernel.org, linux-mm@kvack.org,
 linux-sh@vger.kernel.org, linux-usb@vger.kernel.org,
 samba-technical@lists.samba.org, sparclinux@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-doc@vger.kernel.org,
 linux-serial@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
 "Takashi Iwai" <tiwai@suse.de>, linux-input@vger.kernel.org,
 linux-raid@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-modules@vger.kernel.org, linux-debuggers@vger.kernel.org
Message-Id: <58f6bc57-d6e2-446f-932a-8104b73cb654@app.fastmail.com>
In-Reply-To: <20261102-work-procfs-fs-v1-3-d09a996317b3@kernel.org>
References: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
 <20261102-work-procfs-fs-v1-3-d09a996317b3@kernel.org>
Subject: Re: [PATCH RFC 03/27] lockd: let procfs copy in writes to nlm_end_grace
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Mon, Nov 2, 2026, at 10:07 AM, Christian Brauner wrote:
> Implement ->proc_write_buf() so procfs copies in what is written before
> it pins the entry. simple_transaction_get() was only used to get a copy
> of what was written, so look at procfs' copy instead and drop the
> transaction. A second write to the same file doesn't fail with -EBUSY
> anymore. Writes larger than PAGE_SIZE - 1 bytes fail with -EINVAL from
> procfs instead of -EFBIG from simple_transaction_get(), which refused a
> few bytes less.
>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Acked-by: Chuck Lever <cel@kernel.org>


-- 
Chuck Lever (Come to NFS bake-a-thon! https://nfsv4bat.org)
