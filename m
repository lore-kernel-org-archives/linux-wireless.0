Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.171]:44363 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253AbXJPQL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 12:11:59 -0400
Received: by ug-out-1314.google.com with SMTP id z38so110988ugc
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2007 09:11:58 -0700 (PDT)
Message-ID: <43e72e890710160911p44404ccbl85ee64ae7a4608fa@mail.gmail.com> (sfid-20071016_171201_876913_7CB5F9B0)
Date: Tue, 16 Oct 2007 12:11:56 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 3/3] consistently use ath5k in printks
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
In-Reply-To: <1192540838-26985-4-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1192540838-26985-1-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-2-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-3-git-send-email-bruno@thinktube.com>
	 <1192540838-26985-4-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/16/07, Bruno Randolf <bruno@thinktube.com> wrote:
> changed all ocurrences of "ath_pci" and "ath" in printks and debug messages to
> "ath5k", to avoid confusion with the madwifi driver.
>
> changed the module version to "0.0.1 (EXPERIMENTAL)" instead of the old one
> which came from the madwifi-bsd branch.
>
> the proc interface changed too from /proc/sys/dev/ath/ to /proc/sys/dev/ath5k/
>
> Signed-off-by: Bruno Randolf <bruno@thinktube.com>

Thanks for this too -- it might be easier to stick to using dev_info()
then. See ath_pci_probe() for a usage of it. This in turn will now
print "ath5k".

  Luis
