Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61112 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757467Ab2HISCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 14:02:39 -0400
Received: by mail-wi0-f172.google.com with SMTP id hm11so601987wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 09 Aug 2012 11:02:39 -0700 (PDT)
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH 13/13] compat-wireless: Add DRM patches
Date: Thu,  9 Aug 2012 21:01:32 +0300
Message-Id: <1344535292-4451-14-git-send-email-ozancag@gmail.com> (sfid-20120809_200259_350316_DAD81F05)
In-Reply-To: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
References: <1344535292-4451-1-git-send-email-ozancag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bring DRM patches from compat-drm GSoC tree.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 patches/drm/01-dma_buf_ops-addition.patch         |  54 +++
 patches/drm/02-revert-vm_mmap.patch               | 100 ++++++
 patches/drm/03-swiotlb.patch                      |  87 +++++
 patches/drm/04-revert-prime-support.patch         | 384 ++++++++++++++++++++++
 patches/drm/05-i915-define-acpi-video-class.patch |  18 +
 patches/drm/98-pr_fmt.patch                       | 199 +++++++++++
 patches/drm/99-change-makefile.patch              |  28 ++
 7 files changed, 870 insertions(+)
 create mode 100644 patches/drm/01-dma_buf_ops-addition.patch
 create mode 100644 patches/drm/02-revert-vm_mmap.patch
 create mode 100644 patches/drm/03-swiotlb.patch
 create mode 100644 patches/drm/04-revert-prime-support.patch
 create mode 100644 patches/drm/05-i915-define-acpi-video-class.patch
 create mode 100644 patches/drm/98-pr_fmt.patch
 create mode 100644 patches/drm/99-change-makefile.patch

diff --git a/patches/drm/01-dma_buf_ops-addition.patch b/patches/drm/01-dma_buf_ops-addition.patch
new file mode 100644
index 0000000..ee95cb5
--- /dev/null
+++ b/patches/drm/01-dma_buf_ops-addition.patch
@@ -0,0 +1,54 @@
+Assign vmap, vunmap and mmap fields in dma_buf_ops structs only
+if kernel version >= 3.5.0 as they are added in 3.5.
+
+Note that the dma-buf itself was added with 3.4. It is not available
+on kernels < 3.4.
+
+Index: compat-drm/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/i915_gem_dmabuf.c
++++ compat-drm/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+@@ -159,9 +159,11 @@ static const struct dma_buf_ops i915_dma
+ 	.kmap_atomic = i915_gem_dmabuf_kmap_atomic,
+ 	.kunmap = i915_gem_dmabuf_kunmap,
+ 	.kunmap_atomic = i915_gem_dmabuf_kunmap_atomic,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,5,0))
+ 	.mmap = i915_gem_dmabuf_mmap,
+ 	.vmap = i915_gem_dmabuf_vmap,
+ 	.vunmap = i915_gem_dmabuf_vunmap,
++#endif
+ };
+ 
+ struct dma_buf *i915_gem_prime_export(struct drm_device *dev,
+Index: compat-drm/drivers/gpu/drm/nouveau/nouveau_prime.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/nouveau/nouveau_prime.c
++++ compat-drm/drivers/gpu/drm/nouveau/nouveau_prime.c
+@@ -111,9 +111,11 @@ static const struct dma_buf_ops nouveau_
+ 	.kmap_atomic = nouveau_gem_kmap_atomic,
+ 	.kunmap = nouveau_gem_kunmap,
+ 	.kunmap_atomic = nouveau_gem_kunmap_atomic,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,5,0))
+ 	.mmap = nouveau_gem_prime_mmap,
+ 	.vmap = nouveau_gem_prime_vmap,
+ 	.vunmap = nouveau_gem_prime_vunmap,
++#endif
+ };
+ 
+ static int
+Index: compat-drm/drivers/gpu/drm/radeon/radeon_prime.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/radeon/radeon_prime.c
++++ compat-drm/drivers/gpu/drm/radeon/radeon_prime.c
+@@ -134,9 +134,11 @@ const static struct dma_buf_ops radeon_d
+ 	.kmap_atomic = radeon_gem_kmap_atomic,
+ 	.kunmap = radeon_gem_kunmap,
+ 	.kunmap_atomic = radeon_gem_kunmap_atomic,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,5,0))
+ 	.mmap = radeon_gem_prime_mmap,
+ 	.vmap = radeon_gem_prime_vmap,
+ 	.vunmap = radeon_gem_prime_vunmap,
++#endif
+ };
+ 
+ static int radeon_prime_create(struct drm_device *dev,
diff --git a/patches/drm/02-revert-vm_mmap.patch b/patches/drm/02-revert-vm_mmap.patch
new file mode 100644
index 0000000..aec746a
--- /dev/null
+++ b/patches/drm/02-revert-vm_mmap.patch
@@ -0,0 +1,100 @@
+vm_mmap() and vm_munmap() were introduced in kernels >= 3.4.0. Revert
+those changes for versions older than that.
+
+These can't be backported as they rely on non-exported symbols.
+
+Index: compat-drm/drivers/gpu/drm/drm_bufs.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/drm_bufs.c
++++ compat-drm/drivers/gpu/drm/drm_bufs.c
+@@ -1553,6 +1553,20 @@ int drm_mapbufs(struct drm_device *dev,
+ 				retcode = -EINVAL;
+ 				goto done;
+ 			}
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
++			down_write(&current->mm->mmap_sem);
++			virtual = do_mmap(file_priv->filp, 0, map->size,
++					  PROT_READ | PROT_WRITE,
++					  MAP_SHARED,
++					  token);
++			up_write(&current->mm->mmap_sem);
++		} else {
++			down_write(&current->mm->mmap_sem);
++			virtual = do_mmap(file_priv->filp, 0, dma->byte_count,
++					  PROT_READ | PROT_WRITE,
++					  MAP_SHARED, 0);
++			up_write(&current->mm->mmap_sem);
++#else
+ 			virtual = vm_mmap(file_priv->filp, 0, map->size,
+ 					  PROT_READ | PROT_WRITE,
+ 					  MAP_SHARED,
+@@ -1561,6 +1575,7 @@ int drm_mapbufs(struct drm_device *dev,
+ 			virtual = vm_mmap(file_priv->filp, 0, dma->byte_count,
+ 					  PROT_READ | PROT_WRITE,
+ 					  MAP_SHARED, 0);
++#endif
+ 		}
+ 		if (virtual > -1024UL) {
+ 			/* Real error */
+Index: compat-drm/drivers/gpu/drm/i810/i810_dma.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i810/i810_dma.c
++++ compat-drm/drivers/gpu/drm/i810/i810_dma.c
+@@ -133,9 +133,17 @@ static int i810_map_buffer(struct drm_bu
+ 	old_fops = file_priv->filp->f_op;
+ 	file_priv->filp->f_op = &i810_buffer_fops;
+ 	dev_priv->mmap_buffer = buf;
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
++	down_write(&current->mm->mmap_sem);
++	buf_priv->virtual = (void *)do_mmap(file_priv->filp, 0, buf->total,
++					    PROT_READ | PROT_WRITE,
++					    MAP_SHARED, buf->bus_address);
++	up_write(&current->mm->mmap_sem);
++#else
+ 	buf_priv->virtual = (void *)vm_mmap(file_priv->filp, 0, buf->total,
+ 					    PROT_READ | PROT_WRITE,
+ 					    MAP_SHARED, buf->bus_address);
++#endif
+ 	dev_priv->mmap_buffer = NULL;
+ 	file_priv->filp->f_op = old_fops;
+ 	if (IS_ERR(buf_priv->virtual)) {
+@@ -156,9 +164,15 @@ static int i810_unmap_buffer(struct drm_
+ 	if (buf_priv->currently_mapped != I810_BUF_MAPPED)
+ 		return -EINVAL;
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
++	down_write(&current->mm->mmap_sem);
++	retcode = do_munmap(current->mm, (unsigned long)buf_priv->virtual,
++			    (size_t) buf->total);
++	up_write(&current->mm->mmap_sem);
++#else
+ 	retcode = vm_munmap((unsigned long)buf_priv->virtual,
+ 			    (size_t) buf->total);
+-
++#endif
+ 	buf_priv->currently_mapped = I810_BUF_UNMAPPED;
+ 	buf_priv->virtual = NULL;
+ 
+Index: compat-drm/drivers/gpu/drm/i915/i915_gem.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/i915_gem.c
++++ compat-drm/drivers/gpu/drm/i915/i915_gem.c
+@@ -1045,10 +1045,17 @@ i915_gem_mmap_ioctl(struct drm_device *d
+ 		drm_gem_object_unreference_unlocked(obj);
+ 		return -EINVAL;
+ 	}
+-
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,4,0))
++	down_write(&current->mm->mmap_sem);
++	addr = do_mmap(obj->filp, 0, args->size,
++		       PROT_READ | PROT_WRITE, MAP_SHARED,
++		       args->offset);
++	up_write(&current->mm->mmap_sem);
++#else
+ 	addr = vm_mmap(obj->filp, 0, args->size,
+ 		       PROT_READ | PROT_WRITE, MAP_SHARED,
+ 		       args->offset);
++#endif
+ 	drm_gem_object_unreference_unlocked(obj);
+ 	if (IS_ERR((void *)addr))
+ 		return addr;
diff --git a/patches/drm/03-swiotlb.patch b/patches/drm/03-swiotlb.patch
new file mode 100644
index 0000000..eaa583b
--- /dev/null
+++ b/patches/drm/03-swiotlb.patch
@@ -0,0 +1,87 @@
+
+swiotlb_nr_tbl() was available since 3.2 but was exported since 3.3.
+Since it uses an internal global state variable, it is impossible
+to backport it to compat.git. So revert the changes.
+
+Index: compat-drm/drivers/gpu/drm/nouveau/nouveau_bo.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/nouveau/nouveau_bo.c
++++ compat-drm/drivers/gpu/drm/nouveau/nouveau_bo.c
+@@ -1297,11 +1297,13 @@ nouveau_ttm_tt_populate(struct ttm_tt *t
+ 	}
+ #endif
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0))
+ #ifdef CONFIG_SWIOTLB
+ 	if (swiotlb_nr_tbl()) {
+ 		return ttm_dma_populate((void *)ttm, dev->dev);
+ 	}
+ #endif
++#endif
+ 
+ 	r = ttm_pool_populate(ttm);
+ 	if (r) {
+@@ -1347,12 +1349,14 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt
+ 	}
+ #endif
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0))
+ #ifdef CONFIG_SWIOTLB
+ 	if (swiotlb_nr_tbl()) {
+ 		ttm_dma_unpopulate((void *)ttm, dev->dev);
+ 		return;
+ 	}
+ #endif
++#endif
+ 
+ 	for (i = 0; i < ttm->num_pages; i++) {
+ 		if (ttm_dma->dma_address[i]) {
+Index: compat-drm/drivers/gpu/drm/radeon/radeon_ttm.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/radeon/radeon_ttm.c
++++ compat-drm/drivers/gpu/drm/radeon/radeon_ttm.c
+@@ -630,11 +630,13 @@ static int radeon_ttm_tt_populate(struct
+ 	}
+ #endif
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0))
+ #ifdef CONFIG_SWIOTLB
+ 	if (swiotlb_nr_tbl()) {
+ 		return ttm_dma_populate(&gtt->ttm, rdev->dev);
+ 	}
+ #endif
++#endif
+ 
+ 	r = ttm_pool_populate(ttm);
+ 	if (r) {
+@@ -676,12 +678,14 @@ static void radeon_ttm_tt_unpopulate(str
+ 	}
+ #endif
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0))
+ #ifdef CONFIG_SWIOTLB
+ 	if (swiotlb_nr_tbl()) {
+ 		ttm_dma_unpopulate(&gtt->ttm, rdev->dev);
+ 		return;
+ 	}
+ #endif
++#endif
+ 
+ 	for (i = 0; i < ttm->num_pages; i++) {
+ 		if (gtt->ttm.dma_address[i]) {
+@@ -906,6 +910,7 @@ static int radeon_ttm_debugfs_init(struc
+ 	radeon_mem_types_list[i].show = &ttm_page_alloc_debugfs;
+ 	radeon_mem_types_list[i].driver_features = 0;
+ 	radeon_mem_types_list[i++].data = NULL;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,3,0))
+ #ifdef CONFIG_SWIOTLB
+ 	if (swiotlb_nr_tbl()) {
+ 		sprintf(radeon_mem_types_names[i], "ttm_dma_page_pool");
+@@ -915,6 +920,7 @@ static int radeon_ttm_debugfs_init(struc
+ 		radeon_mem_types_list[i++].data = NULL;
+ 	}
+ #endif
++#endif
+ 	return radeon_debugfs_add_files(rdev, radeon_mem_types_list, i);
+ 
+ #endif
diff --git a/patches/drm/04-revert-prime-support.patch b/patches/drm/04-revert-prime-support.patch
new file mode 100644
index 0000000..c835790
--- /dev/null
+++ b/patches/drm/04-revert-prime-support.patch
@@ -0,0 +1,384 @@
+Disable PRIME support in core drm, radeon, nouveau and i915 for
+kernels < 3.4.0.
+
+PRIME depends on dma-buf which is added to the kernel with 3.3 but
+the one in 3.3 is mostly stub, e.g. it is a skeleton API which
+is highly modified in 3.4. So disable PRIME for kernels < 3.4.0,
+not < 3.3.0.
+
+Index: compat-drm/drivers/gpu/drm/drm_drv.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/drm_drv.c
++++ compat-drm/drivers/gpu/drm/drm_drv.c
+@@ -137,8 +137,10 @@ static struct drm_ioctl_desc drm_ioctls[
+ 
+ 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETRESOURCES, drm_mode_getresources, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	DRM_IOCTL_DEF(DRM_IOCTL_PRIME_HANDLE_TO_FD, drm_prime_handle_to_fd_ioctl, DRM_AUTH|DRM_UNLOCKED),
+ 	DRM_IOCTL_DEF(DRM_IOCTL_PRIME_FD_TO_HANDLE, drm_prime_fd_to_handle_ioctl, DRM_AUTH|DRM_UNLOCKED),
++#endif
+ 
+ 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETPLANERESOURCES, drm_mode_getplane_res, DRM_MASTER|DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+ 	DRM_IOCTL_DEF(DRM_IOCTL_MODE_GETCRTC, drm_mode_getcrtc, DRM_CONTROL_ALLOW|DRM_UNLOCKED),
+Index: compat-drm/drivers/gpu/drm/drm_fops.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/drm_fops.c
++++ compat-drm/drivers/gpu/drm/drm_fops.c
+@@ -271,8 +271,10 @@ static int drm_open_helper(struct inode
+ 	if (dev->driver->driver_features & DRIVER_GEM)
+ 		drm_gem_open(dev, priv);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	if (drm_core_check_feature(dev, DRIVER_PRIME))
+ 		drm_prime_init_file_private(&priv->prime);
++#endif
+ 
+ 	if (dev->driver->open) {
+ 		ret = dev->driver->open(dev, priv);
+@@ -575,8 +577,10 @@ int drm_release(struct inode *inode, str
+ 	if (dev->driver->postclose)
+ 		dev->driver->postclose(dev, file_priv);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	if (drm_core_check_feature(dev, DRIVER_PRIME))
+ 		drm_prime_destroy_file_private(&file_priv->prime);
++#endif
+ 
+ 	kfree(file_priv);
+ 
+Index: compat-drm/drivers/gpu/drm/drm_gem.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/drm_gem.c
++++ compat-drm/drivers/gpu/drm/drm_gem.c
+@@ -35,7 +35,11 @@
+ #include <linux/mman.h>
+ #include <linux/pagemap.h>
+ #include <linux/shmem_fs.h>
++
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ #include <linux/dma-buf.h>
++#endif
++
+ #include "drmP.h"
+ 
+ /** @file drm_gem.c
+@@ -204,6 +208,7 @@ EXPORT_SYMBOL(drm_gem_object_alloc);
+ static void
+ drm_gem_remove_prime_handles(struct drm_gem_object *obj, struct drm_file *filp)
+ {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	if (obj->import_attach) {
+ 		drm_prime_remove_imported_buf_handle(&filp->prime,
+ 				obj->import_attach->dmabuf);
+@@ -212,6 +217,7 @@ drm_gem_remove_prime_handles(struct drm_
+ 		drm_prime_remove_imported_buf_handle(&filp->prime,
+ 				obj->export_dma_buf);
+ 	}
++#endif
+ }
+ 
+ /**
+Index: compat-drm/drivers/gpu/drm/drm_prime.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/drm_prime.c
++++ compat-drm/drivers/gpu/drm/drm_prime.c
+@@ -26,6 +26,8 @@
+  *
+  */
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
++
+ #include <linux/export.h>
+ #include <linux/dma-buf.h>
+ #include "drmP.h"
+@@ -350,3 +352,4 @@ void drm_prime_remove_imported_buf_handl
+ 	mutex_unlock(&prime_fpriv->lock);
+ }
+ EXPORT_SYMBOL(drm_prime_remove_imported_buf_handle);
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0)) */
+Index: compat-drm/drivers/gpu/drm/nouveau/nouveau_prime.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/nouveau/nouveau_prime.c
++++ compat-drm/drivers/gpu/drm/nouveau/nouveau_prime.c
+@@ -22,6 +22,7 @@
+  * Authors: Dave Airlie
+  */
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ #include "drmP.h"
+ #include "drm.h"
+ 
+@@ -230,4 +231,4 @@ fail_detach:
+ 	dma_buf_detach(dma_buf, attach);
+ 	return ERR_PTR(ret);
+ }
+-
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0)) */
+Index: compat-drm/drivers/gpu/drm/radeon/radeon_prime.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/radeon/radeon_prime.c
++++ compat-drm/drivers/gpu/drm/radeon/radeon_prime.c
+@@ -23,6 +23,8 @@
+  *
+  * Authors: Alex Deucher
+  */
++
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ #include "drmP.h"
+ #include "drm.h"
+ 
+@@ -226,3 +228,4 @@ fail_detach:
+ 	dma_buf_detach(dma_buf, attach);
+ 	return ERR_PTR(ret);
+ }
++#endif /* (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0)) */
+Index: compat-drm/drivers/gpu/drm/radeon/radeon_drv.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/radeon/radeon_drv.c
++++ compat-drm/drivers/gpu/drm/radeon/radeon_drv.c
+@@ -340,8 +340,10 @@ static const struct file_operations rade
+ static struct drm_driver kms_driver = {
+ 	.driver_features =
+ 	    DRIVER_USE_AGP | DRIVER_USE_MTRR | DRIVER_PCI_DMA | DRIVER_SG |
+-	    DRIVER_HAVE_IRQ | DRIVER_HAVE_DMA | DRIVER_IRQ_SHARED | DRIVER_GEM |
+-	    DRIVER_PRIME,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
++	    DRIVER_PRIME |
++#endif
++	    DRIVER_HAVE_IRQ | DRIVER_HAVE_DMA | DRIVER_IRQ_SHARED | DRIVER_GEM,
+ 	.dev_priv_size = 0,
+ 	.load = radeon_driver_load_kms,
+ 	.firstopen = radeon_driver_firstopen_kms,
+@@ -377,10 +379,12 @@ static struct drm_driver kms_driver = {
+ 	.dumb_destroy = radeon_mode_dumb_destroy,
+ 	.fops = &radeon_driver_kms_fops,
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
+ 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
+ 	.gem_prime_export = radeon_gem_prime_export,
+ 	.gem_prime_import = radeon_gem_prime_import,
++#endif
+ 
+ 	.name = DRIVER_NAME,
+ 	.desc = DRIVER_DESC,
+Index: compat-drm/drivers/gpu/drm/radeon/radeon_gem.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/radeon/radeon_gem.c
++++ compat-drm/drivers/gpu/drm/radeon/radeon_gem.c
+@@ -42,8 +42,10 @@ void radeon_gem_object_free(struct drm_g
+ 	struct radeon_bo *robj = gem_to_radeon_bo(gobj);
+ 
+ 	if (robj) {
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 		if (robj->gem_base.import_attach)
+ 			drm_prime_gem_destroy(&robj->gem_base, robj->tbo.sg);
++#endif
+ 		radeon_bo_unref(&robj);
+ 	}
+ }
+Index: compat-drm/drivers/gpu/drm/radeon/radeon_ttm.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/radeon/radeon_ttm.c
++++ compat-drm/drivers/gpu/drm/radeon/radeon_ttm.c
+@@ -583,17 +583,21 @@ static int radeon_ttm_tt_populate(struct
+ 	struct radeon_ttm_tt *gtt = (void *)ttm;
+ 	unsigned i;
+ 	int r;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
++#endif
+ 
+ 	if (ttm->state != tt_unpopulated)
+ 		return 0;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	if (slave && ttm->sg) {
+ 		drm_prime_sg_to_page_addr_arrays(ttm->sg, ttm->pages,
+ 						 gtt->ttm.dma_address, ttm->num_pages);
+ 		ttm->state = tt_unbound;
+ 		return 0;
+ 	}
++#endif
+ 
+ 	rdev = radeon_get_rdev(ttm->bdev);
+ #if __OS_HAS_AGP
+@@ -637,10 +641,12 @@ static void radeon_ttm_tt_unpopulate(str
+ 	struct radeon_device *rdev;
+ 	struct radeon_ttm_tt *gtt = (void *)ttm;
+ 	unsigned i;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
+ 
+ 	if (slave)
+ 		return;
++#endif
+ 
+ 	rdev = radeon_get_rdev(ttm->bdev);
+ #if __OS_HAS_AGP
+Index: compat-drm/drivers/gpu/drm/nouveau/nouveau_bo.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/nouveau/nouveau_bo.c
++++ compat-drm/drivers/gpu/drm/nouveau/nouveau_bo.c
+@@ -1275,11 +1275,14 @@ nouveau_ttm_tt_populate(struct ttm_tt *t
+ 	struct drm_device *dev;
+ 	unsigned i;
+ 	int r;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
++#endif
+ 
+ 	if (ttm->state != tt_unpopulated)
+ 		return 0;
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	if (slave && ttm->sg) {
+ 		/* make userspace faulting work */
+ 		drm_prime_sg_to_page_addr_arrays(ttm->sg, ttm->pages,
+@@ -1287,6 +1290,7 @@ nouveau_ttm_tt_populate(struct ttm_tt *t
+ 		ttm->state = tt_unbound;
+ 		return 0;
+ 	}
++#endif
+ 
+ 	dev_priv = nouveau_bdev(ttm->bdev);
+ 	dev = dev_priv->dev;
+@@ -1334,10 +1338,12 @@ nouveau_ttm_tt_unpopulate(struct ttm_tt
+ 	struct drm_nouveau_private *dev_priv;
+ 	struct drm_device *dev;
+ 	unsigned i;
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	bool slave = !!(ttm->page_flags & TTM_PAGE_FLAG_SG);
+ 
+ 	if (slave)
+ 		return;
++#endif
+ 
+ 	dev_priv = nouveau_bdev(ttm->bdev);
+ 	dev = dev_priv->dev;
+Index: compat-drm/drivers/gpu/drm/nouveau/nouveau_drv.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/nouveau/nouveau_drv.c
++++ compat-drm/drivers/gpu/drm/nouveau/nouveau_drv.c
+@@ -403,7 +403,10 @@ static struct drm_driver driver = {
+ 	.driver_features =
+ 		DRIVER_USE_AGP | DRIVER_PCI_DMA | DRIVER_SG |
+ 		DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | DRIVER_GEM |
+-		DRIVER_MODESET | DRIVER_PRIME,
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
++		DRIVER_PRIME |
++#endif
++		DRIVER_MODESET,
+ 	.load = nouveau_load,
+ 	.firstopen = nouveau_firstopen,
+ 	.lastclose = nouveau_lastclose,
+@@ -426,10 +429,12 @@ static struct drm_driver driver = {
+ 	.ioctls = nouveau_ioctls,
+ 	.fops = &nouveau_driver_fops,
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
+ 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
+ 	.gem_prime_export = nouveau_gem_prime_export,
+ 	.gem_prime_import = nouveau_gem_prime_import,
++#endif
+ 
+ 	.gem_init_object = nouveau_gem_object_new,
+ 	.gem_free_object = nouveau_gem_object_del,
+Index: compat-drm/drivers/gpu/drm/nouveau/nouveau_gem.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/nouveau/nouveau_gem.c
++++ compat-drm/drivers/gpu/drm/nouveau/nouveau_gem.c
+@@ -23,7 +23,9 @@
+  * WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
+  *
+  */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ #include <linux/dma-buf.h>
++#endif
+ #include "drmP.h"
+ #include "drm.h"
+ 
+@@ -55,8 +57,10 @@ nouveau_gem_object_del(struct drm_gem_ob
+ 		nouveau_bo_unpin(nvbo);
+ 	}
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	if (gem->import_attach)
+ 		drm_prime_gem_destroy(gem, nvbo->bo.sg);
++#endif
+ 
+ 	ttm_bo_unref(&bo);
+ 
+Index: compat-drm/drivers/gpu/drm/i915/i915_drv.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/i915_drv.c
++++ compat-drm/drivers/gpu/drm/i915/i915_drv.c
+@@ -1050,7 +1050,11 @@ static struct drm_driver driver = {
+ 	 */
+ 	.driver_features =
+ 	    DRIVER_USE_AGP | DRIVER_REQUIRE_AGP | /* DRIVER_USE_MTRR |*/
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	    DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | DRIVER_GEM | DRIVER_PRIME,
++#else
++	    DRIVER_HAVE_IRQ | DRIVER_IRQ_SHARED | DRIVER_GEM,
++#endif
+ 	.load = i915_driver_load,
+ 	.unload = i915_driver_unload,
+ 	.open = i915_driver_open,
+@@ -1074,10 +1078,12 @@ static struct drm_driver driver = {
+ 	.gem_free_object = i915_gem_free_object,
+ 	.gem_vm_ops = &i915_gem_vm_ops,
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	.prime_handle_to_fd = drm_gem_prime_handle_to_fd,
+ 	.prime_fd_to_handle = drm_gem_prime_fd_to_handle,
+ 	.gem_prime_export = i915_gem_prime_export,
+ 	.gem_prime_import = i915_gem_prime_import,
++#endif
+ 
+ 	.dumb_create = i915_gem_dumb_create,
+ 	.dumb_map_offset = i915_gem_mmap_gtt,
+Index: compat-drm/drivers/gpu/drm/i915/i915_gem.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/i915_gem.c
++++ compat-drm/drivers/gpu/drm/i915/i915_gem.c
+@@ -35,7 +35,9 @@
+ #include <linux/slab.h>
+ #include <linux/swap.h>
+ #include <linux/pci.h>
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ #include <linux/dma-buf.h>
++#endif
+ 
+ static __must_check int i915_gem_object_flush_gpu_write_domain(struct drm_i915_gem_object *obj);
+ static void i915_gem_object_flush_gtt_write_domain(struct drm_i915_gem_object *obj);
+@@ -3522,8 +3524,10 @@ void i915_gem_free_object(struct drm_gem
+ 
+ 	trace_i915_gem_object_destroy(obj);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ 	if (gem_obj->import_attach)
+ 		drm_prime_gem_destroy(gem_obj, obj->sg_table);
++#endif
+ 
+ 	if (obj->phys_obj)
+ 		i915_gem_detach_phys_object(dev, obj);
+Index: compat-drm/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/i915_gem_dmabuf.c
++++ compat-drm/drivers/gpu/drm/i915/i915_gem_dmabuf.c
+@@ -23,6 +23,7 @@
+  * Authors:
+  *	Dave Airlie <airlied@redhat.com>
+  */
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,4,0))
+ #include "drmP.h"
+ #include "i915_drv.h"
+ #include <linux/dma-buf.h>
+@@ -232,3 +233,4 @@ fail_detach:
+ 	dma_buf_detach(dma_buf, attach);
+ 	return ERR_PTR(ret);
+ }
++#endif
diff --git a/patches/drm/05-i915-define-acpi-video-class.patch b/patches/drm/05-i915-define-acpi-video-class.patch
new file mode 100644
index 0000000..7fddd3b
--- /dev/null
+++ b/patches/drm/05-i915-define-acpi-video-class.patch
@@ -0,0 +1,18 @@
+The definition of ACPI_VIDEO_CLASS was moved from video.c
+to video.h in 3.1. Define it here to fix build for kernels older
+than 3.1.
+
+Index: compat-drm/drivers/gpu/drm/i915/intel_opregion.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/intel_opregion.c
++++ compat-drm/drivers/gpu/drm/i915/intel_opregion.c
+@@ -307,6 +307,9 @@ static int intel_opregion_video_event(st
+ 	struct acpi_bus_event *event = data;
+ 	int ret = NOTIFY_OK;
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0))
++#define ACPI_VIDEO_CLASS "video"
++#endif
+ 	if (strcmp(event->device_class, ACPI_VIDEO_CLASS) != 0)
+ 		return NOTIFY_DONE;
+ 
diff --git a/patches/drm/98-pr_fmt.patch b/patches/drm/98-pr_fmt.patch
new file mode 100644
index 0000000..1b0680b
--- /dev/null
+++ b/patches/drm/98-pr_fmt.patch
@@ -0,0 +1,199 @@
+
+Undef/define/include printk.h for fixing redefinition warnings
+during build.
+
+Patch adapted from compat-wireless tree.
+
+Index: compat-drm/drivers/gpu/drm/ttm/ttm_agp_backend.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/ttm/ttm_agp_backend.c
++++ compat-drm/drivers/gpu/drm/ttm/ttm_agp_backend.c
+@@ -29,8 +29,10 @@
+  *          Keith Packard.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "[TTM] " fmt
+ 
++#include <linux/printk.h>
+ #include "ttm/ttm_module.h"
+ #include "ttm/ttm_bo_driver.h"
+ #include "ttm/ttm_page_alloc.h"
+Index: compat-drm/drivers/gpu/drm/ttm/ttm_bo.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/ttm/ttm_bo.c
++++ compat-drm/drivers/gpu/drm/ttm/ttm_bo.c
+@@ -28,11 +28,13 @@
+  * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "[TTM] " fmt
+ 
+ #include "ttm/ttm_module.h"
+ #include "ttm/ttm_bo_driver.h"
+ #include "ttm/ttm_placement.h"
++#include <linux/printk.h>
+ #include <linux/jiffies.h>
+ #include <linux/slab.h>
+ #include <linux/sched.h>
+Index: compat-drm/drivers/gpu/drm/ttm/ttm_bo_vm.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/ttm/ttm_bo_vm.c
++++ compat-drm/drivers/gpu/drm/ttm/ttm_bo_vm.c
+@@ -28,8 +28,10 @@
+  * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "[TTM] " fmt
+ 
++#include <linux/printk.h>
+ #include <ttm/ttm_module.h>
+ #include <ttm/ttm_bo_driver.h>
+ #include <ttm/ttm_placement.h>
+Index: compat-drm/drivers/gpu/drm/ttm/ttm_memory.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/ttm/ttm_memory.c
++++ compat-drm/drivers/gpu/drm/ttm/ttm_memory.c
+@@ -25,11 +25,13 @@
+  *
+  **************************************************************************/
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "[TTM] " fmt
+ 
+ #include "ttm/ttm_memory.h"
+ #include "ttm/ttm_module.h"
+ #include "ttm/ttm_page_alloc.h"
++#include <linux/printk.h>
+ #include <linux/spinlock.h>
+ #include <linux/sched.h>
+ #include <linux/wait.h>
+Index: compat-drm/drivers/gpu/drm/ttm/ttm_object.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/ttm/ttm_object.c
++++ compat-drm/drivers/gpu/drm/ttm/ttm_object.c
+@@ -49,10 +49,12 @@
+  * for fast lookup of ref objects given a base object.
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "[TTM] " fmt
+ 
+ #include "ttm/ttm_object.h"
+ #include "ttm/ttm_module.h"
++#include <linux/printk.h>
+ #include <linux/list.h>
+ #include <linux/spinlock.h>
+ #include <linux/slab.h>
+Index: compat-drm/drivers/gpu/drm/ttm/ttm_page_alloc.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/ttm/ttm_page_alloc.c
++++ compat-drm/drivers/gpu/drm/ttm/ttm_page_alloc.c
+@@ -31,8 +31,10 @@
+  * - doesn't track currently in use pages
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "[TTM] " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/list.h>
+ #include <linux/spinlock.h>
+ #include <linux/highmem.h>
+Index: compat-drm/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
++++ compat-drm/drivers/gpu/drm/ttm/ttm_page_alloc_dma.c
+@@ -33,8 +33,10 @@
+  *   when freed).
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "[TTM] " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/dma-mapping.h>
+ #include <linux/list.h>
+ #include <linux/seq_file.h> /* for seq_printf */
+Index: compat-drm/drivers/gpu/drm/ttm/ttm_tt.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/ttm/ttm_tt.c
++++ compat-drm/drivers/gpu/drm/ttm/ttm_tt.c
+@@ -28,8 +28,10 @@
+  * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) "[TTM] " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/sched.h>
+ #include <linux/highmem.h>
+ #include <linux/pagemap.h>
+Index: compat-drm/drivers/gpu/drm/i915/i915_dma.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/i915_dma.c
++++ compat-drm/drivers/gpu/drm/i915/i915_dma.c
+@@ -26,6 +26,7 @@
+  *
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
+ #include "drmP.h"
+@@ -36,6 +37,7 @@
+ #include "i915_drm.h"
+ #include "i915_drv.h"
+ #include "i915_trace.h"
++#include <linux/printk.h>
+ #include <linux/pci.h>
+ #include <linux/vgaarb.h>
+ #include <linux/acpi.h>
+Index: compat-drm/drivers/gpu/drm/i915/i915_irq.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/i915_irq.c
++++ compat-drm/drivers/gpu/drm/i915/i915_irq.c
+@@ -26,8 +26,10 @@
+  *
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/sysrq.h>
+ #include <linux/slab.h>
+ #include "drmP.h"
+Index: compat-drm/drivers/gpu/drm/i915/intel_opregion.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/intel_opregion.c
++++ compat-drm/drivers/gpu/drm/i915/intel_opregion.c
+@@ -25,8 +25,10 @@
+  *
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/acpi.h>
+ #include <linux/acpi_io.h>
+ #include <acpi/video.h>
+Index: compat-drm/drivers/gpu/drm/i915/intel_panel.c
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/i915/intel_panel.c
++++ compat-drm/drivers/gpu/drm/i915/intel_panel.c
+@@ -28,8 +28,10 @@
+  *      Chris Wilson <chris@chris-wilson.co.uk>
+  */
+ 
++#undef pr_fmt
+ #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+ 
++#include <linux/printk.h>
+ #include <linux/moduleparam.h>
+ #include "intel_drv.h"
+ 
diff --git a/patches/drm/99-change-makefile.patch b/patches/drm/99-change-makefile.patch
new file mode 100644
index 0000000..882a02d
--- /dev/null
+++ b/patches/drm/99-change-makefile.patch
@@ -0,0 +1,28 @@
+Remove drivers that we do not want to build from gpu/drm/Makefile
+
+Index: compat-drm/drivers/gpu/drm/Makefile
+===================================================================
+--- compat-drm.orig/drivers/gpu/drm/Makefile
++++ compat-drm/drivers/gpu/drm/Makefile
+@@ -28,21 +28,14 @@ CFLAGS_drm_trace_points.o := -I$(src)
+ obj-$(CONFIG_DRM)	+= drm.o
+ obj-$(CONFIG_DRM_USB)   += drm_usb.o
+ obj-$(CONFIG_DRM_TTM)	+= ttm/
+-obj-$(CONFIG_DRM_TDFX)	+= tdfx/
+-obj-$(CONFIG_DRM_R128)	+= r128/
+ obj-$(CONFIG_DRM_RADEON)+= radeon/
+-obj-$(CONFIG_DRM_MGA)	+= mga/
+ obj-$(CONFIG_DRM_I810)	+= i810/
+ obj-$(CONFIG_DRM_I915)  += i915/
+ obj-$(CONFIG_DRM_MGAG200) += mgag200/
+ obj-$(CONFIG_DRM_CIRRUS_QEMU) += cirrus/
+-obj-$(CONFIG_DRM_SIS)   += sis/
+-obj-$(CONFIG_DRM_SAVAGE)+= savage/
+ obj-$(CONFIG_DRM_VMWGFX)+= vmwgfx/
+ obj-$(CONFIG_DRM_VIA)	+=via/
+ obj-$(CONFIG_DRM_NOUVEAU) +=nouveau/
+-obj-$(CONFIG_DRM_EXYNOS) +=exynos/
+ obj-$(CONFIG_DRM_GMA500) += gma500/
+-obj-$(CONFIG_DRM_UDL) += udl/
+ obj-$(CONFIG_DRM_AST) += ast/
+ obj-y			+= i2c/
-- 
1.7.11.2

