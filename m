Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:19968 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751968AbeEGKK5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 06:10:57 -0400
Subject: Re: WARNING in kernfs_add_one
To: Greg KH <gregkh@linuxfoundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+df47f81c226b31d89fb1@syzkaller.appspotmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tj@kernel.org, Johannes Berg <johannes@sipsolutions.net>
References: <0000000000000390eb056b77596d@google.com>
 <20180505164041.GD7746@kroah.com>
 <095bc684-0029-0b2e-5e28-23376174ca02@gmail.com>
 <20180505220721.GA10829@kroah.com>
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-ID: <7e25235d-0a11-87fb-cf81-56d6c13f40b0@I-love.SAKURA.ne.jp> (sfid-20180507_121101_136709_901E5733)
Date: Mon, 7 May 2018 19:10:31 +0900
MIME-Version: 1.0
In-Reply-To: <20180505220721.GA10829@kroah.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/05/06 7:07, Greg KH wrote:
>> More likely wireless territory
> 
> Ugh, that's what I get for writing emails before coffee in the
> morning...
> 
> Yes, you are right, this looks like a wireless issue.
> 
> Now cc: linux-wireless.
> 
Nope, if you look at previous fault injection messages...



>From 7ddcaa3d4327d4f29d11053bd2011bf77ecf72af Mon Sep 17 00:00:00 2001
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Date: Mon, 7 May 2018 14:19:50 +0900
Subject: [PATCH] driver core: Don't ignore class_dir_create_and_add() failure.

syzbot is hitting WARN() at kernfs_add_one() [1].
This is because kernfs_create_link() is confused by previous device_add()
call which continued without setting dev->kobj.parent field when
get_device_parent() failed by memory allocation fault injection.
Fix this by propagating the error from class_dir_create_and_add() to
the calllers of get_device_parent().

[1] https://syzkaller.appspot.com/bug?id=fae0fb607989ea744526d1c082a5b8de6529116f

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reported-by: syzbot <syzbot+df47f81c226b31d89fb1@syzkaller.appspotmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index b610816..d680fd0 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1467,7 +1467,7 @@ class_dir_create_and_add(struct class *class, struct kobject *parent_kobj)
 
 	dir = kzalloc(sizeof(*dir), GFP_KERNEL);
 	if (!dir)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	dir->class = class;
 	kobject_init(&dir->kobj, &class_dir_ktype);
@@ -1477,7 +1477,7 @@ class_dir_create_and_add(struct class *class, struct kobject *parent_kobj)
 	retval = kobject_add(&dir->kobj, parent_kobj, "%s", class->name);
 	if (retval < 0) {
 		kobject_put(&dir->kobj);
-		return NULL;
+		return ERR_PTR(retval);
 	}
 	return &dir->kobj;
 }
@@ -1784,6 +1784,10 @@ int device_add(struct device *dev)
 
 	parent = get_device(dev->parent);
 	kobj = get_device_parent(dev, parent);
+	if (IS_ERR(kobj)) {
+		error = PTR_ERR(kobj);
+		goto parent_error;
+	}
 	if (kobj)
 		dev->kobj.parent = kobj;
 
@@ -1882,6 +1886,7 @@ int device_add(struct device *dev)
 	kobject_del(&dev->kobj);
  Error:
 	cleanup_glue_dir(dev, glue_dir);
+parent_error:
 	put_device(parent);
 name_error:
 	kfree(dev->p);
@@ -2701,6 +2706,11 @@ int device_move(struct device *dev, struct device *new_parent,
 	device_pm_lock();
 	new_parent = get_device(new_parent);
 	new_parent_kobj = get_device_parent(dev, new_parent);
+	if (IS_ERR(new_parent_kobj)) {
+		error = PTR_ERR(new_parent_kobj);
+		put_device(new_parent);
+		goto out;
+	}
 
 	pr_debug("device: '%s': %s: moving to '%s'\n", dev_name(dev),
 		 __func__, new_parent ? dev_name(new_parent) : "<NULL>");
-- 
1.8.3.1
