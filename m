Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7261738F651;
	Tue, 15 Sep 2026 07:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458156; cv=pass; b=Uyh2DbNUVxLPNy4HFwbaWj9U3cwwGBNrwfFBOg4VCPumZOXOAkipbgPXMTkQPbhFJT/Rx7wakttlqrIzJX9aVkPTmWpnXvVa3dQiXrsIFev8dpk+SXqa2iVTJm/92yt7rWnspz88bCflmMRYj3o1ymsEAg4UTN+jmH4hBRg20vA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458156; c=relaxed/simple;
	bh=4oPVfTuLdoKRiL1KhOv4pI7rErvpJxgcey+RwhBBvFU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e7o0NtP1KvlQNwGRuduSSkIMwL1uGYeqRUZAbB9LZvwjZlu5nU96/ftW1CMtXe3lTJCC/L6HnWH07TQgVxmslFRZITLwwApIgRtHeWTCWB906+BXXHfS55qEEVP9bKE6W/dpojnYHbUS+FNtAk4DaPDYU4mY0QH1ONPXMrDOtjc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=DbL/TjAg; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="DbL/TjAg"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkYrh3T1rz49Q6x;
	Tue, 15 Sep 2026 10:42:28 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789458148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n6wZoihAX0RzIzEuG6gPIj7VNZNxAWj7RdKbKT8wUj4=;
	b=DbL/TjAggprTV6dX3LE381p36qm0gloLTtNjgx/mDDgp/idnKGo6vUih8O7rr+fHROzbxp
	73uz/MHmgJP8vb3qcZRZ0JLkTYhhWTg69YW8r4YDKWHfjzyHELCL52HpP7kCFDr3Hdqwpi
	9acmt0nqGXzBTWtrM7JLbImSxIHhXTg8oXSn9nrSggeEV9clEkgcXiD2KraCgeGATSV85k
	Tig02z/K5aPKnj7XVwktWqsJOogaFSkouRJpeZl4acdLmyZhNXHOfAxOon4csejjRIyifL
	MbzfQK5ipwBWovIek9XGQSmCzBVCA9pHrgXpdtHuRFvMnPnN42WXUV5xNyJ2LA==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789458148;
	b=wca5xElpb59PpnQ26j3OJ0zFUIxNaOeOHE7Ii9tqP0JFrcue2oQvZJLbkCftwoJWcIezd2
	hXeGzDgqvqECYgYRysJkASf98K5k3TRhFzO0nu64CVvMO+apHoGP2rab/zyJVYCwyl/8kE
	ApX1QWOXFAyCLX4ucmrbm7+wK963Z41p/dc5sXX2AVUeFjySaFmq6XHT1C/bAd6cGBNM5Y
	ivgQxW46v7TwoBjWXGxc3P6ZZeFvUnHaKEaSQbxQKgW3D/vCT5c+bu2sI/lXbDMyg0lvjh
	uWBESnYtaBDZR+r9cIsFN3aVwhzX3cs55LzpFlxtnUziIY3uxj4WXSUL56aXAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789458148;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n6wZoihAX0RzIzEuG6gPIj7VNZNxAWj7RdKbKT8wUj4=;
	b=glLpRHNux0v35r6NxrqX0XuDzTfv/vqeqWrSRTW5a5HyFOnNUm6KSp3x5sVx8FldnCelVS
	7uZZ5YhKqXKI1Hkgv923Vc7UZd7WFJvP0T0IVqfnS8DzBxTu75+BjjG0y+AdFrJnQHL/MO
	Ul3UDBKGB4p3NR274q6A06qGqBmBOIUFq56TQLg54HosmMBYZ0xIScHCk9DAjqLvTZRtZw
	OtBFddJc96rXV25FMRe24A73mcxqVzy7HrjmX+fxbXs7HQ3ag6Yu4mjQkzRZBRDVvbMEqB
	SjUYwxCEANToYTxJG8YAZn0j63OQqtw99fnyf0lEum+71d6I4rEY5FSYx2sxGA==
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
Subject: [PATCH v4 02/12] bus: mhi: allow mhi to know about its qrtr endpoint id and free it
Date: Tue, 15 Sep 2026 10:41:25 +0300
Message-Id: <20260915074135.2567411-3-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
References: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It is slightly less than ideal to have MHI know about its QRTR endpoint
id, since MHI can be compiled in without QRTR. However, since many users
of MHI use QRTR, I was bold enough to edit the MHI controller data
structure. The only alternative to this editing is to have a hash table
or worse, an O(N) lookup list inside QRTR to turn MHI controller data
pointer to QRTR endpoint id.  However, even in that case the QRTR
endpoint id needs to be freed when the MHI controller is freed, so it is
impossible to do this in a non-leaky way without editing MHI controller.

It's a good question whether the QRTR endpoint it should be stored to
mhi_controller or mhi_device. In most cases, it shouldn't matter, as two
PCIe ath11k/ath12k cards have two mhi_controllers. So, I followed the
original idea by Mihai Moldovan that mhi_controller has 1:1 relationship
to QRTR endpoint.

MHI controller needs a function pointer to actually free the QRTR
endpoint id, since MHI can be compiled in without QRTR, so the freeing
has to happen externally.

Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 drivers/bus/mhi/host/init.c | 8 ++++++++
 include/linux/mhi.h         | 5 +++++
 2 files changed, 13 insertions(+)

diff --git a/drivers/bus/mhi/host/init.c b/drivers/bus/mhi/host/init.c
index fd3050889412d..d96b099432640 100644
--- a/drivers/bus/mhi/host/init.c
+++ b/drivers/bus/mhi/host/init.c
@@ -947,6 +947,9 @@ int mhi_register_controller(struct mhi_controller *mhi_cntrl,
 	rwlock_init(&mhi_cntrl->pm_lock);
 	spin_lock_init(&mhi_cntrl->transition_lock);
 	spin_lock_init(&mhi_cntrl->wlock);
+	spin_lock_init(&mhi_cntrl->qrtr_endpoint_lock);
+	mhi_cntrl->qrtr_endpoint_id = 0;
+	mhi_cntrl->free_qrtr_endpoint_id = NULL;
 	INIT_WORK(&mhi_cntrl->st_worker, mhi_pm_st_worker);
 	init_waitqueue_head(&mhi_cntrl->state_event);
 
@@ -1087,6 +1090,11 @@ void mhi_unregister_controller(struct mhi_controller *mhi_cntrl)
 	put_device(&mhi_dev->dev);
 
 	ida_free(&mhi_controller_ida, mhi_cntrl->index);
+
+	spin_lock(&mhi_cntrl->qrtr_endpoint_lock);
+	if (mhi_cntrl->free_qrtr_endpoint_id)
+		mhi_cntrl->free_qrtr_endpoint_id(mhi_cntrl);
+	spin_unlock(&mhi_cntrl->qrtr_endpoint_lock);
 }
 EXPORT_SYMBOL_GPL(mhi_unregister_controller);
 
diff --git a/include/linux/mhi.h b/include/linux/mhi.h
index 8616bacd8675d..d6d5c93e41cb0 100644
--- a/include/linux/mhi.h
+++ b/include/linux/mhi.h
@@ -361,6 +361,7 @@ struct mhi_controller_config {
  * @st_worker: State transition worker
  * @hiprio_wq: High priority workqueue for MHI work such as state transitions
  * @state_event: State change event
+ * @qrtr_endpoint_id: The QRTR endpoint id associated with this MHI controller
  * @status_cb: CB function to notify power states of the device (required)
  * @wake_get: CB function to assert device wake (optional)
  * @wake_put: CB function to de-assert device wake (optional)
@@ -373,6 +374,7 @@ struct mhi_controller_config {
  * @write_reg: Write a MHI register via the physical link (required)
  * @reset: Controller specific reset function (optional)
  * @edl_trigger: CB function to trigger EDL mode (optional)
+ * @free_qrtr_endpoint_id: Function to free the QRTR endpoint id
  * @buffer_len: Bounce buffer length
  * @index: Index of the MHI controller instance
  * @bounce_buf: Use of bounce buffer
@@ -440,6 +442,8 @@ struct mhi_controller {
 	struct work_struct st_worker;
 	struct workqueue_struct *hiprio_wq;
 	wait_queue_head_t state_event;
+	u32 qrtr_endpoint_id;
+	spinlock_t qrtr_endpoint_lock;
 
 	void (*status_cb)(struct mhi_controller *mhi_cntrl,
 			  enum mhi_callback cb);
@@ -458,6 +462,7 @@ struct mhi_controller {
 			  u32 val);
 	void (*reset)(struct mhi_controller *mhi_cntrl);
 	int (*edl_trigger)(struct mhi_controller *mhi_cntrl);
+	void (*free_qrtr_endpoint_id)(void *mhi_cntrl_void);
 
 	size_t buffer_len;
 	int index;
-- 
2.34.1

