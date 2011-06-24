Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43794 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab1FXKmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 06:42:07 -0400
Received: by pzk9 with SMTP id 9so1701116pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2011 03:42:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308908074-4163-1-git-send-email-sgruszka@redhat.com>
References: <1308908074-4163-1-git-send-email-sgruszka@redhat.com>
Date: Fri, 24 Jun 2011 13:42:05 +0300
Message-ID: <BANLkTi=xV4xSE_8cdMcQtC3zDFSNgHq1kg@mail.gmail.com> (sfid-20110624_124211_687270_8F4F629A)
Subject: Re: [PATCH] iwlagn: fix rmmod crash
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 24, 2011 at 12:34, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> priv->bus.bus_specific pointer is used after priv structures was freed,
> in iwl_pci_remove(), what make ugly rmmod crash. This bug was introduced
> by current pci changes.

Oops... You are definitely right. Strangely enough, I was very lucky
when I run the 500 cycles of rmmod insmod.

Thanks for the fix !
