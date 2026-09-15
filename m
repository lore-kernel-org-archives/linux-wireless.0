Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFD5385516;
	Tue, 15 Sep 2026 07:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458120; cv=pass; b=oAvTXWdyl5tCQXnqt6rdY0wygozBFL6hl5jiOsOq8K6QQF8GDjSx6CxZ4VY0sFLdmKDzgj0lBLTaZw2wp7O9asLwrLeUmfJ0lSXa9+l8itDPDcCnC0Fd55d5RVw3iPBq65RwPJZ3A0lg8leZnrRy7fD4cVPdYXv1TK1N2/MtbFo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458120; c=relaxed/simple;
	bh=X/iyW8vBZDEOiO2/97e/ngwvB6JIeCH6254Ywj0M2nM=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=aJoGfcPLFFccp81HIR/WJW0Zv1PBCVdxEN7EgRgtsBiplqJ2LwZuFG0pBEWNbiJDDMbk87iYmwEmL6IgWZat+ouBCHzRAmm5ww1+PC8KT93UoNRW7OxwgXlW7UZuSg5NwyP2UCDWj/+vc+Tv5kmMaLbFCuSh5419Po6JvtweyUA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=Z72AKOPc; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="Z72AKOPc"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkYqy3frGz49Q8v;
	Tue, 15 Sep 2026 10:41:50 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789458111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ssjCicGyqdEYNlBdjuFRU3fGeHRj22ijyH8dQwc3Jdg=;
	b=Z72AKOPchycwD7uoAEroeVFqA+EL/N2NscmB6SPnyjipZJeHZok6pK1n69Ua0Iamba6sap
	aSq69KWQAuTFT9rq9LivMFnnJUOjaxz8vpcbw2wf4DzNsy8qH/+6B3PHeT/1jsI8Y7qPmn
	1y3YaoIu2tZZEoQFwstATZUyndZU4ihnBApfoxuyRxKl0jfwBc6lsjcBGE8jBeM6qbfKs/
	3o4xkI23oVWTjNJmGIu9PdZCwhkbQV9Zqm9QmYn1XLJA9zwrWJkcNWxsIUYkCFOWvXuUNM
	djimGj6lgWrZCnxR26eTZJ2rK5Ivc0JmwhEYLPnWvMuLEc30J8Gx/R/Ae/A5zQ==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789458111;
	b=DuFi0m3P3o448fxh15cnpF4hZa9qSD69q3pVyrooOsaTOTCJSn5qKBDMK3hD98BIuJCmb5
	8BvmiDo5AS/wytf4cYzwlWGJwEBU0AK11ZGShQ0X1BcWirFFV0W1a0Ds2NLDSaueRtzE0+
	0De1qQ8H24NYzHnmtRFzx2P0O4nIDTsZu5bRn8DNKUTTEJ6KLKbt2HgqpeR54D6zJ4JZRr
	pg7HTFYAFNsds/4mnYsjNXsvIF5s/2AUJcJOYqM7C+vLIu/L4WMMJntD3gccO4kb2F8QI2
	tdNeLgGYHzZ2ZVo8L3tA76dJvBoE3uqKNzyXD/zlNY4M8x/AMgAihb228/Z6AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789458111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=ssjCicGyqdEYNlBdjuFRU3fGeHRj22ijyH8dQwc3Jdg=;
	b=LVNC8uhk2kOw/YnMpNICeNpkTzOy3tbsUVFYvIbEd5/mrbo71HvdsahJkxUqNuks/N6qHp
	ZYiWi4mookIvJoyMhTUg5ZOWvb7nku3XApHVXbR0a3JJmmG9e/ISyt3qE2pWYqDajT/IoJ
	OXMXnT2tFWgZpkcc3h9JsQt4oOOJH/XkRyinnq4j+oHI5eeGnWsL25Qfp7qQWBgzwYBaGD
	iPAKx3KeTdj6wc9vLYuDxTQfKtqO2f+H2R/QFesLVZ8ey0CIFW0la7DPJuM1xKfDeKTfkH
	YPvJmUgwP1uYPzV5oO0brS6hUcU+LMpNzlalnaVCBLZaFrtZuBt5W5NWXnICYA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	Mihai Moldovan <ionic@ionic.de>,
	Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v4 00/12] ath1{1,2}k: support multiple PCI devices in one system
Date: Tue, 15 Sep 2026 10:41:23 +0300
Message-Id: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hello,

As you may well know, multiple identical ath11k and ath12k devices are
not supported in a single Linux host because they use conflicting QRTR
node IDs. Fortunately, Denis Kenzior created a patchset to support
multiple QRTR endpoints with identical node IDs, and Mihai Moldovan
refined it, after which I took over the patchset and refined it more.

Mihai Moldovan also created a patchset for actually adding the support
for this QRTR multi-endpoint feature to ath11k and ath12k drivers.
Unfortunately, the code of Mihai was not merge-quality, since it leaked
memory if you ran rmmod and modprobe inside a loop. Mihai mentioned this
drawback, without providing an API for deleting endpoints or usage of
such API in code that's responsible for freeing resources. Also Mihai's
patchset had a race condition.

Since Mihai has been busy recently and the previous iteration of this
patchset is nearly 2 years old, I decided to "steal" the patchset from
him since he said he doesn't care who eventually implements this, as
long as it "just works". I am willing to give the responsibility of this
patchset back to Mihai if he so wants.

I reverted back to the approach where MHI knows the QRTR endpoint id.
This is somewhat ugly, but really the only way resources can be freed
(unless you resort to some kind of reference counting which would be
doable in kernel, or garbage-collection which wouldn't be doable). It
does create some extra memory usage in the mhi_controller data
structure, but a large fraction of the time, the data there is useful,
since a large fraction of MHI devices actually use QRTR. So this is not
as bad as making every PCI device know its QRTR endpoint ID (which a
vast majority don't have), even though MHI can be compiled in without
QRTR so we have to do the freeing via a function pointer.

I think the code is mostly merge-quality now. It does require the QRTR
multi-endpoint support, such as this v7:

https://msgid.link/20260915054207.2513877-1-juha-matti.tilli@iki.fi

I tested it on dual ath11k setup, but more testers would be good. If you
only have a single ath11k card, your testing is useful too ("given
enough races, all race conditions are shallow").

Link to Github if you don't want to apply patches manually from mails:

https://github.com/jmtilli/linux/tree/athnext_multi_qrtr_v7_multi_ath11k_ath12k_v4

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218480

Mihai mentioned in Bugzilla in comment 21 that there was a hardware
crash he couldn't reproduce and he believed it's a race condition. I
could reproduce it in older Mihai's patchset version by treating -EEXIST
as an error, which indeed points to it being a race condition. I believe
the source was qrtr_endpoint_id_get_or_assign that tried to get an ID
and then assign an ID if it couldn't get one, while not holding a
spinlock. In my newest patchset, my belief is this race condition is
gone (the entire offending function is gone), but any kind of review
about thread-safety of my code would be good input.

Original description:

ath11k and ath12k suffer from a long-standing issue that is partly
caused by the QRTR implementation, which only supports one device per
node/port combination and partly caused by the fact that the
QMI instance ID of the devices are statically set to 1.

P Praneesh <quic_ppranees at quicinc.com> submitted a patch[0] that fixes
this issue generating a unique QMI instance ID based on the PCI bus data
for the device and passing that information to the QMI subsystem and the
device's firmware via a special PCI register.

However, it quickly turned out that this approach works for the hardware
he tested, but fails for other ath11k-based devices, including the
popular QCA6930, since its firmware just ignores the special register
being used.

Since we need QMI (and, for matter, QRTR) to work for the initial
firmware upload, this approach will not work generically.

Fortunately, Denis Kenzior <denkenz at gmail.com> cooked up a patch set for
QRTR[1] that introduces the concept of endpoint IDs, which are
dynamically allocated and can be used to distinguish different devices
even though they use the same node/port combination. Using this patch
set, endpoint IDs can be reported as part of auxiliary data in the QRTR
socket and bound to for client sockets, which will automatically filter
messages from other endpoints and also make sure that client messages
are routed to the correct endpoint.

This looked promising, and with that functionality, the only challenge
is to find out the correct endpoint IDs and bind to them in drivers to
finally support multiple devices in a generic way.

This patch set implements exactly that, and it WORKSFORME, but
unfortunately it turns out that "the only challenge" is very difficult
to overcome due to the socket-based architecture.

ath1{1,2}k and QRTR are at opposite sides of the socket, with QRTR
assigning endpoint IDs and ath1{1,2}k needing a way to fetch and operate
on them.

The endpoint reporting feature in QRTR is not helpful in this case,
because drivers do not generally know which endpoint belongs to the
device they currently handle (i.e., there is no central registry) and
even if we were to snoop on the socket and take the first endpoint ID we
are unaware of, this might not be the correct one, because it might be
in use by a different driver for instance, or correspond to a different
device.

The first iteration of this patch set[2] extended struct mhi_device with
a qrtr_endpoint_id field that was initialized to zero and populated by
the QRTR MHI driver as soon as it was loaded. Drivers could then query
this field through an mhi_device->mhi_cntrl->mhi_device chain (if they
also use the MHI bus, of course). This, however, was an incredibly ugly
hack because QRTR data should not be part of MHI device structures in
the first place, timing is critical (drivers querying the endpoint ID
must do so after the QRTR MHI module initialized, which is typically
only the case after QRTR socket was created) and it was not possible to
query or pre-assign an endpoint ID before creating a socket and directly
bind to it (which might lead to races such as seeing messages over the
socket that are not meant for the endpoint ID drivers are actually
interested in).

Since that was not elegant at all, and due to the other mentioned
issues, this iteration uses a different approach: endpoint IDs can now
be associated with (private) backend endpoint-specific data, which
allows us to identify which endpoint ID is being used with what backend,
and additionally new API is introduced so that other parts in the kernel
can either get an endpoint ID for given endpoint-specific data or even
attach endpoint-specific data to a new endpoint ID generated by the QRTR
driver. The QRTR system will try to use endpoint-specific data if
possible, but falls back to generating endpoint IDs without
endpoint-specific data (as in, NULL pointer) if that did not work.

Crucially, the endpoint-specific data pointer is used as an opaque void
pointer and at most compared with data stored in the endpoints XArray.

In the QRTR MHI backend, we use the MHI controller's structure pointer
as endpoint-specific data, and since the MHI controller is also the bus
master and responsible for the physical link, clients (drivers) can
pre-register an endpoint ID for their MHI controllers and directly tell
QMI to bind to the endpoint ID at socket creation time.

The QRTR SMD backend uses its rpmsg_device pointer and the TUN backend
uses the inode pointer as their respective endpoint-specific data
pointers.

This approach is cleaner and works better, because it is not prone to
races (although it requires coordination between QRTR backends and
clients/drivers because both must use the same endpoint-specific data
for the scheme to work).

There are, however, also issues with this approach:
  - Any kernel part can generate an unlimited number of endpoint IDs
    with arbitrary pointers. The amount of endpoint IDs that can be
    tracked is limited, though, so there is potential for exhaustion of ID
    space.
  - Since previously endpoint IDs were only generated by the QRTR
    subsystem, there was no need to use any kind of life cycle management
    for the endpoint IDs: they were created at node creation time and
    also deleted at node deletion time. Since other subsystems can now
    create endpoint IDs, it would probably be good to have a way to
    reclaim created but unused endpoint IDs. No such implementation is
    provided here.
  - Multiple PCI/MHI devices will work, but no AHB + PCI/MHI interaction
    has been tested. Since PCI/MHI devices bind to their endpoint ID,
    these will likely work, but the AHB devices might still see messages
    for all endpoints and fail to work correctly. AHB devices seem to be
    using QMI and thus also QRTR, but without a specific QRTR backend
    driver (going through REMOTEPROC instead?), so this approach might
    not be viable for AHB devices.

I am much more comfortable with this patch set, even if it has some
rough edges and might not fix the situation for AHB devices.

[0] https://patch.msgid.link/20230111170033.32454-1-kvalo@kernel.org
[1] https://patch.msgid.link/20241018181842.1368394-1-denkenz@gmail.com
[2] https://msgid.link/cover.1730790058.git.ionic@ionic.de

v4:
  - eliminate two duplicate function declarations
  - new recipient list (To:, Cc:)
  - hopefully send all messages in a single thread
  - Link to v3:
    https://msgid.link/20260908093145.2492666-1-juha-matti.tilli@iki.fi

v3:
  - rebase against current ath-next
  - solved a major memory leak
  - replaced O(N) algorithm by O(1) where N is the leaked memory
  - solved all known race condition issues
  - Link to v2: https://msgid.link/cover.1732506261.git.ionic@ionic.de

v2: code and metadata cleanup (checkpatch.pl), no functional changes

BR, Juha-Matti

Juha-Matti Tilli (5):
  net: qrtr: support getting new endpoint ids externally
  bus: mhi: allow mhi to know about its qrtr endpoint id and free it
  net: qrtr: mhi: register new qrtr endpoint id for mhi
  wifi: ath11k: implement QRTR endpoint ID fetching for PCI
  wifi: ath12k: implement QRTR endpoint ID fetching for PCI

Mihai Moldovan (7):
  soc: qcom: qmi_helpers: add QRTR endpoint ID to qmi_handle
  soc: qcom: qmi_helpers: optionally bind to QRTR endpoint ID in
    qmi_sock_create
  wifi: ath11k: add QRTR endpoint ID hif feature
  wifi: ath11k: stub QRTR endpoint ID fetching
  wifi: ath11k: bind to QRTR endpoint ID in ath11k_qmi_init_service
  wifi: ath12k: add QRTR endpoint ID hif feature
  wifi: ath12k: bind to QRTR endpoint ID in ath12k_qmi_init_service

 MAINTAINERS                           |  1 +
 drivers/bus/mhi/host/init.c           |  8 +++++
 drivers/net/wireless/ath/ath11k/ahb.c |  7 ++++
 drivers/net/wireless/ath/ath11k/hif.h |  9 ++++++
 drivers/net/wireless/ath/ath11k/mhi.c | 46 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath11k/mhi.h |  1 +
 drivers/net/wireless/ath/ath11k/pci.c |  1 +
 drivers/net/wireless/ath/ath11k/qmi.c |  8 +++++
 drivers/net/wireless/ath/ath12k/hif.h | 10 ++++++
 drivers/net/wireless/ath/ath12k/mhi.c | 46 +++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath12k/mhi.h |  3 ++
 drivers/net/wireless/ath/ath12k/pci.c |  1 +
 drivers/net/wireless/ath/ath12k/qmi.c |  9 ++++++
 drivers/soc/qcom/qmi_interface.c      | 28 ++++++++++++++++
 include/linux/mhi.h                   |  5 +++
 include/linux/soc/qcom/qmi.h          |  3 ++
 include/net/qrtr.h                    | 10 ++++++
 net/qrtr/af_qrtr.c                    | 42 ++++++++++++++++++++----
 net/qrtr/mhi.c                        | 32 +++++++++++++++++++
 net/qrtr/qrtr.h                       |  2 ++
 20 files changed, 266 insertions(+), 6 deletions(-)
 create mode 100644 include/net/qrtr.h

-- 
2.34.1

