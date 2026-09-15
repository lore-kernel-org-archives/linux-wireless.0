Received: from pidgin.makrotopia.org (pidgin.makrotopia.org [185.142.180.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47004372B57;
	Tue, 15 Sep 2026 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.142.180.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789480780; cv=none; b=liodNQusgmi3i6LYObY/apuAjum068jznq45o/qil3v8jq2KGK7x60BLEBng8Q+FnuNmPbsIjHV+a7v9wQSvOimI7bkdVRytD0FP8eLbxXbqY9nnEi7q620qW7ku8NZNG9I69X9JnRYMG30Ky0XNwlP3pOnEn8yVJ4S+ELm81kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789480780; c=relaxed/simple;
	bh=MPNwDySajHBTgQoxxPTy4tz7FJNKza+ZVwhy6UjvdYw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LVu+3KroDA7+yQTKFycOsn0PHrCXLr5rqv2np3nyOtxPWnhJqu9dUqzK3jiLIxPgEgEiuMBkE/A0oKVTQQ9DsmjgvB1wjho7TStShILIySu+WrUcWQ+wLQIF/aU1QIcO7+XHlA6Op0cGRU+UPhh8KKUVc4F9LoKbVL04epw0iW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org; spf=pass smtp.mailfrom=makrotopia.org; arc=none smtp.client-ip=185.142.180.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=makrotopia.org
Received: from local
	by pidgin.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256:X25519MLKEM768)
	 (Exim 4.100)
	(envelope-from <daniel@makrotopia.org>)
	id 1x6Th5-000000000fl-1rZv;
	Tue, 15 Sep 2026 13:59:31 +0000
Date: Tue, 15 Sep 2026 14:59:27 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans de Goede <johannes.goede@oss.qualcomm.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Marco Crivellari <marco.crivellari@suse.com>,
	driver-core@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] device_schedule_reprobe(): core helper and
 conversions
Message-ID: <aqlPPyblTK8c6-zZ@makrotopia.org>
References: <anpxFdwNxk0XwPjQ@makrotopia.org>
 <2026081139-strenuous-greasily-f4e5@gregkh>
 <cb0d42dd-4755-49a8-8a05-297e4283914e@oss.qualcomm.com>
 <2026081133-crazy-enquirer-97ce@gregkh>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026081133-crazy-enquirer-97ce@gregkh>

On Tue, Aug 11, 2026 at 05:07:47PM +0900, Greg Kroah-Hartman wrote:
> That feels a bit better, as long as this code really is "safe" :)
>
> So, how can this be tested and fixed up so it isn't an RFC anymore?

The helper went out as v2 [1] and v3 [2] on its own, and it now travels
as patch 3 of the mxl862xx devlink flash series [3], whose driver is
its first user: that driver reflashes a DSA switch over MDIO and has no
in-place path back, so it reinitialises through a deferred detach and
re-probe. Patch 4 of that series does not link without the helper and
the series cannot be split around it, so what it needs from the driver
core is an ack on that patch.

On testing. Every firmware flash and every recovery in that series ends
in device_schedule_reprobe(), so the helper is on the path of all of
the following, run on an MxL86252C switch of the BananaPi R4 Pro 8X: an
upgrade through fwupd; a reboot issued while a flash was running, which
waits for the transfer to finish; a host crash in the middle of a
transfer, whose wedged download the driver drains in the background
before re-probing; and a power cut in the middle of a transfer, after
which the bootloader came up ready and fwupd flashed the switch back to
a released firmware. That kernel was built with PROVE_LOCKING,
PROVE_RCU, DEBUG_LOCK_ALLOC, DEBUG_MUTEXES, DEBUG_SPINLOCK,
DEBUG_RT_MUTEXES, DEBUG_WW_MUTEX_SLOWPATH, DEBUG_ATOMIC_SLEEP, KASAN
(generic), UBSAN, DETECT_HUNG_TASK and SOFTLOCKUP_DETECTOR, on PREEMPT,
and the logs were clean.

On the fixing up, since the version in this thread:

The helper adds no state to the driver core. That version grew a
shutdown_done bit in struct device_private, set from device_shutdown();
the work now tests defer_all_probes instead, which device_shutdown()
and dpm_prepare() both set before they touch any device. base.h and
core.c are untouched, so the patch is dd.c and device.h only.

Nothing is locked in the caller's context, and the parent is neither
pinned nor locked. Recording dev->parent and taking
__device_driver_lock() meant the device lock was taken where the caller
stands, which inverted against the devlink instance lock that a devlink
flash holds across the call, and a pinned parent can be replaced by
device_move() without any device lock held. The work now takes
device_lock(dev) alone, and a bus that sets need_parent_lock is refused
with -EINVAL when the re-probe is scheduled. usb_bus_type is the only
such bus in the tree, and the three conversions re-probe PCI and serdev
devices, so none of them is refused.

__device_release_driver() reports whether it released the driver, and
takes an abort_if_blocked flag. It drops the device lock while busy
consumer links are unbound; on re-acquisition it re-checks
defer_all_probes and abandons the release, which closes the window
where a ->remove() could follow a ->shutdown() on the same device. Only
the deferred re-probe passes true, since an administrative unbind has
to complete and driver_detach() would spin on a device it never
released. Because the work learns whether it was the call that released
the driver, an unbind winning that race is no longer undone by the
re-attach.

The work runs on system_freezable_wq rather than the unbound queue
Marco commented on, so a re-probe pending across system suspend runs
once the system has resumed, instead of detaching a suspended device or
racing its late suspend callbacks.

-EPROBE_DEFER is kept out of the re-probe error path, where
dev_err_probe() would have recorded it as the device's deferred probe
reason. The kernel-doc no longer promises that an administrative unbind
is never undone, which unbind_store() does not guarantee, and it now
states the calling context and the freezable behaviour.

The conversions of the open-coded users in iwlwifi, hci_h5 and
btintel_pcie follow once the helper is merged, which is the part that
removes the module_get(THIS_MODULE) you objected to. Hans reviewed and
tested the helper and the hci_h5 conversion on RTL8723BS hardware
[4][5]; the helper has changed materially since, so I have not carried
those tags over.

[1] https://lore.kernel.org/all/cover.1787185594.git.daniel@makrotopia.org/
[2] https://lore.kernel.org/all/cover.1787281239.git.daniel@makrotopia.org/
[3] https://lore.kernel.org/all/cover.1789175618.git.daniel@makrotopia.org/
[4] https://lore.kernel.org/all/c461462f-de0b-43e8-ac9e-541013f5f8da@oss.qualcomm.com/
[5] https://lore.kernel.org/all/7ffe0c2e-0742-488a-ab6c-1dc2fabc049c@oss.qualcomm.com/

Thanks,


Daniel
