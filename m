Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:49770 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462Ab3HENbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Aug 2013 09:31:33 -0400
Received: by mail-bk0-f42.google.com with SMTP id jk14so988402bkc.29
        for <linux-wireless@vger.kernel.org>; Mon, 05 Aug 2013 06:31:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1375430329-23352-1-git-send-email-bartosz.markowski@tieto.com>
References: <1375430329-23352-1-git-send-email-bartosz.markowski@tieto.com>
Date: Mon, 5 Aug 2013 15:31:31 +0200
Message-ID: <CA+BoTQkD5grL_5dJDgkwo40ET1zax56oN=ZGFxnyGqboQShbgQ@mail.gmail.com> (sfid-20130805_153138_270771_2B446A97)
Subject: Re: [PATCH v2] ath10k: add SoC power save option to PCI features map
From: Michal Kazior <michal.kazior@tieto.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 August 2013 09:58, Bartosz Markowski <bartosz.markowski@tieto.com> wrote:
> Unify the PCI options location.
>
> By default the SoC PS option is disabled to boost the
> performance and due to poor stability on early HW revisions.
> In future we can remove the module parameter and turn on/off
> the PS for given hardware.
>
> This change also makes the pci module parameter for SoC PS static.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

Hmm.. I'm worried about pci wake/sleep locking:

 (a) pci_wake() (awake count =1)
 (a) do something
 Now, if pci_sleep() and pci_wake() happen simultaneously/are
preempted splitting primitive operations to:
 (a) pci_sleep(): decrease awake count (=0)
 (b) pci_wake(): increase awake count (=1), iowrite, wait for awake, return
 (a) pci_sleep(): iowrite(). return
 The flow in (b) now thinks the device is awake, but it's not
guaranteed to be anymore because it has been put to sleep by (a).


Pozdrawiam / Best regards,
Michał Kazior.
